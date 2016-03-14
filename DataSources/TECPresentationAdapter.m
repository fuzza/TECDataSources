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

@protocol TECExtendedViewProtocol <NSObject>

@property (nonatomic, assign) id dataSource;
@property (nonatomic, assign) id delegate;

@end

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
    ((TECPresentationAdapter<id<TECExtendedViewProtocol>, id> *)self).extendedView.dataSource = nil;
    ((TECPresentationAdapter<id<TECExtendedViewProtocol>, id> *)self).extendedView.delegate = nil;
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
}

- (void)setupExtendedView {
    ((TECPresentationAdapter<id<TECExtendedViewProtocol>, id> *)self).extendedView.dataSource = [self.delegateProxy proxy];
    ((TECPresentationAdapter<id<TECExtendedViewProtocol>, id> *)self).extendedView.delegate = [self.delegateProxy proxy];
}

- (void)setupContentProvider {
    self.contentProvider.presentationAdapter = self;
}

@end
