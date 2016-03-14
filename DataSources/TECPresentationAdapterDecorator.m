//
//  TECPresentationAdapterDecorator.m
//  DataSources
//
//  Created by Petro Korienev on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPresentationAdapterDecorator.h"
#import "TECPresentationAdapter.h"

@interface TECPresentationAdapterDecorator () {
    TECPresentationAdapter *_presentationAdapter;
    __weak id<TECContentProviderProtocol> _contentProvider;
}

@end

@implementation TECPresentationAdapterDecorator

@dynamic extendedView;

- (instancetype)initWithPresentationAdapter:(TECPresentationAdapter *)presentationAdapter {
    NSAssert([presentationAdapter isKindOfClass:[TECPresentationAdapter class]] && ![presentationAdapter isMemberOfClass:[TECPresentationAdapter class]], @"Incorrect presentation adapter for decorate - %@", presentationAdapter);
    _presentationAdapter = presentationAdapter;
    [self stealContentProviderDelegationFromPresentationAdapter];
    return self;
}

- (id<TECContentProviderProtocol>)contentProvider {
    return _contentProvider;
}

- (TECPresentationAdapter *)presentationAdapter {
    return _presentationAdapter;
}

- (void)stealContentProviderDelegationFromPresentationAdapter {
    _presentationAdapter.contentProvider.presentationAdapter = self;
    _contentProvider = _presentationAdapter.contentProvider;
}

#pragma mark - TECContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    if ([_presentationAdapter respondsToSelector:_cmd]) {
        [_presentationAdapter contentProviderDidReloadData:contentProvider];
    }
}

- (void)contentProviderWillChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    if ([_presentationAdapter respondsToSelector:_cmd]) {
        [_presentationAdapter contentProviderWillChangeContent:contentProvider];
    }
}

- (void)contentProviderDidChangeItem:(id)item
                         atIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)newIndexPath {
    if ([_presentationAdapter respondsToSelector:_cmd]) {
        [_presentationAdapter contentProviderDidChangeItem:item
                                               atIndexPath:indexPath
                                             forChangeType:changeType
                                              newIndexPath:newIndexPath];
    }
}

- (void)contentProviderDidChangeSection:(id<TECSectionModelProtocol>)section
                                atIndex:(NSUInteger)index
                          forChangeType:(TECContentProviderSectionChangeType)changeType {
    if ([_presentationAdapter respondsToSelector:_cmd]) {
        [_presentationAdapter contentProviderDidChangeSection:section
                                                      atIndex:index
                                                forChangeType:changeType];
    }
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    if ([_presentationAdapter respondsToSelector:_cmd]) {
        [_presentationAdapter contentProviderDidChangeContent:contentProvider];
    }
}

#pragma mark - Message forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [_presentationAdapter methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_presentationAdapter];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return NO;
}

@end
