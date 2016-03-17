//
//  TECPresentationAdapter.m
//  DataSources
//
//  Created by Petro Korienev on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPresentationAdapter.h"
#import "TECExtender.h"
#import "TECDelegateProxy.h"
#import "TECContentProviderProtocol.h"

@interface TECPresentationAdapter<ExtendedViewType, ExtenderType> ()

@property (nonatomic, strong, readwrite) ExtendedViewType extendedView;
@property (nonatomic, strong, readwrite) id <TECContentProviderProtocol> contentProvider;
@property (nonatomic, strong) TECDelegateProxy *delegateProxy;

@end

@implementation TECPresentationAdapter

@dynamic contentProvider;
@dynamic extendedView;

#pragma mark - Lifecycle

- (instancetype)initWithContentProvider:(id<TECContentProviderProtocol>)contentProvider
                           extendedView:(UIScrollView *)extendedView
                              extenders:(NSArray<TECExtender *> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy {
    self = [self init];
    if(self) {
        self.extendedView = extendedView;
        self.contentProvider = contentProvider;
        self.delegateProxy = delegateProxy;
        
        [self addExtenders:extenders];
        [self setupContentProvider];
    }
    return self;
}

- (void)dealloc {
    [self cleanup];
}

- (void)cleanup {
    if ([self.extendedView respondsToSelector:@selector(setDataSource:)]) {
        [self.extendedView setDataSource:nil];
    }
    if ([self.extendedView respondsToSelector:@selector(setDelegate:)]) {
        [self.extendedView setDelegate:nil];
    }
}

#pragma mark - Extenders configuration

- (void)addExtenders:(NSArray<TECExtender *> *)extenders {
    for(TECExtender *extender in extenders) {
        [self addExtender:extender];
    }
    [self setupExtendedView];
}

- (void)addExtender:(TECExtender *)extender {
    NSParameterAssert(self.extendedView);
    NSParameterAssert(self.contentProvider);
    extender.extendedView = self.extendedView;
    extender.contentProvider = self.contentProvider;
    [self.delegateProxy attachDelegate:extender];
    [extender didSetup];
}

- (void)setupExtendedView {
    if ([self.extendedView respondsToSelector:@selector(setDataSource:)]) {
        [self.extendedView setDataSource:[self.delegateProxy proxy]];
    }
    if ([self.extendedView respondsToSelector:@selector(setDelegate:)]) {
        [self.extendedView setDelegate:[self.delegateProxy proxy]];
    }
}

- (void)setupContentProvider {
    self.contentProvider.presentationAdapter = self;
}

@end
