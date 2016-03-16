//
//  TECPresentationAdapterDecorator.m
//  DataSources
//
//  Created by Petro Korienev on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPresentationAdapterDecorator.h"
#import "TECPresentationAdapter.h"

@interface TECPresentationAdapterDecorator () <TECContentProviderPresentationAdapterProtocol>

@property (nonatomic, strong, readwrite) TECPresentationAdapter *presentationAdapter;
@property (nonatomic, weak, readwrite) id<TECContentProviderProtocol> contentProvider;

@end

@implementation TECPresentationAdapterDecorator

@dynamic extendedView;

+ (id)decoratedInstanceOf:(TECPresentationAdapter *)presentationAdapter {
    return [[self alloc] initWithPresentationAdapter:presentationAdapter];
}

- (id)initWithPresentationAdapter:(TECPresentationAdapter *)presentationAdapter {
    NSAssert([presentationAdapter isKindOfClass:[TECPresentationAdapter class]] && ![presentationAdapter isMemberOfClass:[TECPresentationAdapter class]], @"Incorrect presentation adapter for decorate - %@", presentationAdapter);
    self.presentationAdapter = presentationAdapter;
    [self stealContentProviderDelegationFromPresentationAdapter];
    return self;
}

- (void)stealContentProviderDelegationFromPresentationAdapter {
    self.presentationAdapter.contentProvider.presentationAdapter = self;
    self.contentProvider = self.presentationAdapter.contentProvider;
}

#pragma mark - Message forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.presentationAdapter methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.presentationAdapter respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_presentationAdapter];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([[self class] instancesRespondToSelector:aSelector]) {
        return YES;
    }
    else {
        return [self.presentationAdapter respondsToSelector:aSelector];
    }
}

- (BOOL)isKindOfClass:(Class)aClass {
    return NO;
}

@end
