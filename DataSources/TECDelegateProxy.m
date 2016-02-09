//
//  TECTableViewDelegateProxy.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECDelegateProxy.h"

@interface TECDelegateProxy ()

@property (nonatomic, strong) NSMutableSet *delegates;

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
    self.delegates = [NSMutableSet new];
}

- (void)attachDelegate:(id)delegate {
    [self.delegates addObject:delegate];
}

- (void)detachDelegate:(id)delegate {
    [self.delegates removeObject:delegate];
}

#pragma mark - Message forwarding

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    for(id delegate in self.delegates.allObjects) {
        if([delegate conformsToProtocol:aProtocol]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    for(id delegate in self.delegates.allObjects) {
        if([delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    for(id delegate in self.delegates.allObjects) {
        if([delegate respondsToSelector:selector]) {
            return [delegate methodSignatureForSelector:selector];
        }
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

#pragma mark - Helper methods

- (void)forwardInvocationToAllObjects:(NSInvocation *)invocation {
    for(id delegate in self.delegates.allObjects) {
        if([delegate respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:delegate];
        }
    }
}

- (void)forwardInvocationToFirstResponder:(NSInvocation *)invocation {
    NSMutableArray *respondersArray = [@[] mutableCopy];
    for(id delegate in self.delegates.allObjects) {
        if([delegate respondsToSelector:invocation.selector]) {
            [respondersArray addObject:delegate];
        }
    }
    
    NSParameterAssert(respondersArray.count < 2);
    [invocation invokeWithTarget:respondersArray.firstObject];
}

@end
