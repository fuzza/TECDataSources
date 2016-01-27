//
//  TECTableViewDelegateProxy.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECDelegateProxy.h"

@interface TECDelegateProxy ()

@property (nonatomic, strong) id primaryDelegate;
@property (nonatomic, strong) NSHashTable *secondaryDelegates;

@end

@implementation TECDelegateProxy

- (instancetype)initWithPrimaryDelegate:(id)delegate {
    self.primaryDelegate = delegate;
    [self setupDelegatesCache];
    return self;
}

- (TECDelegateProxy *)proxy {
    return self;
}

- (void)setupDelegatesCache {
    self.secondaryDelegates = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
}

- (void)attachSecondaryDelegate:(id)delegate {
    [self.secondaryDelegates addObject:delegate];
}

- (void)deattachSecondaryDelegate:(id)delegate {
    [self.secondaryDelegates removeObject:delegate];
}

#pragma mark - Message forwarding

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if([self.primaryDelegate conformsToProtocol:aProtocol]) {
        return YES;
    }
    for(id secondaryDelegate in self.secondaryDelegates.allObjects) {
        if([secondaryDelegate conformsToProtocol:aProtocol]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if([self.primaryDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    for(id secondaryDelegate in self.secondaryDelegates.allObjects) {
        if([secondaryDelegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.primaryDelegate methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    BOOL shouldReturnValue = invocation.methodSignature.methodReturnLength;
    if(!shouldReturnValue) {
        [self forwardInvocationToAllObjects:invocation];
    } else {
        [self forwardInvocationToAllObjects:invocation];
    }
}

#pragma mark - Helper methods

- (void)forwardInvocationToAllObjects:(NSInvocation *)invocation {
    [self forwardInvocation:invocation toObject:self.primaryDelegate];
    for(id secondaryDelegate in self.secondaryDelegates.allObjects) {
        [self forwardInvocation:invocation toObject:secondaryDelegate];
    }
}

- (void)forwardInvocationToFirstResponder:(NSInvocation *)invocation {
    NSMutableArray *respondersArray = [@[] mutableCopy];
    if([self.primaryDelegate respondsToSelector:invocation.selector]) {
        [respondersArray addObject:self.primaryDelegate];
    }
    for(id secondaryDelegate in self.secondaryDelegates.allObjects) {
        [self forwardInvocation:invocation toObject:secondaryDelegate];
        if([secondaryDelegate respondsToSelector:invocation.selector]) {
            [respondersArray addObject:secondaryDelegate];
        }
    }
    
    NSParameterAssert(respondersArray.count < 2);
    [invocation invokeWithTarget:respondersArray.firstObject];
}

- (void)forwardInvocation:(NSInvocation *)invocation toObject:(id)object {
    if([object respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:object];
    }
}

@end
