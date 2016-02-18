//
//  TECTableViewDelegateProxy.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECDelegateProxy.h"

@interface TECDelegateProxy ()

@property (nonatomic, strong) NSHashTable *delegates;

@end

@implementation TECDelegateProxy

- (instancetype)init {
    [self setupDelegatesCache];
    return self;
}

- (TECDelegateProxy *)proxy {
    return self;
}

- (void)setupDelegatesCache {
    self.delegates = [NSHashTable weakObjectsHashTable];
}

- (void)attachDelegate:(id)delegate {
    [self.delegates addObject:delegate];
}

- (void)detachDelegate:(id)delegate {
    [self.delegates removeObject:delegate];
}

#pragma mark - NSObject protocol

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    for(id delegate in self.delegates) {
        if([delegate conformsToProtocol:aProtocol]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if([self firstResponderForSelector:aSelector]) {
        return YES;
    }
    return NO;
}

#pragma mark - Message forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id responder = [self firstResponderForSelector:aSelector];
    if(responder) {
        return [responder methodSignatureForSelector:aSelector];
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    BOOL shouldReturnValue = invocation.methodSignature.methodReturnLength;
    if(shouldReturnValue) {
        [self forwardInvocationToFirstResponder:invocation];
    } else {
        [self forwardInvocationToAllObjects:invocation];
    }
}

- (void)forwardInvocationToAllObjects:(NSInvocation *)invocation {
    NSArray *allResponders = [self allRespondersForSelector:invocation.selector];
    for (id responder in allResponders) {
        [invocation invokeWithTarget:responder];
    }
}

- (void)forwardInvocationToFirstResponder:(NSInvocation *)invocation {
    NSArray *allResponders = [self allRespondersForSelector:invocation.selector];
    NSParameterAssert(allResponders.count < 2);
    
    if(allResponders.firstObject) {
        [invocation invokeWithTarget:allResponders.firstObject];
    }
}

#pragma mark - Getting responders

- (id)firstResponderForSelector:(SEL)aSelector {
    for(id delegate in self.delegates) {
        if([delegate respondsToSelector:aSelector]) {
            return delegate;
        }
    }
    return nil;
}

- (NSArray *)allRespondersForSelector:(SEL)aSelector {
    NSMutableArray *respondersArray = [@[] mutableCopy];
    for(id delegate in self.delegates) {
        if([delegate respondsToSelector:aSelector]) {
            [respondersArray addObject:delegate];
        }
    }
    return respondersArray;
}

@end
