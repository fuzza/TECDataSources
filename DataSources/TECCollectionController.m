//
//  TECCollectionController.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionController.h"
#import "TECContentProviderProtocol.h"
#import "TECCollectionViewExtender.h"
#import "TECDelegateProxy.h"

@interface TECCollectionController ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) id <TECContentProviderProtocol> contentProvider;
@property (nonatomic, strong) NSArray <TECCollectionViewExtender *> *extenders;
@property (nonatomic, strong) TECDelegateProxy *delegateProxy;

@end

@implementation TECCollectionController

- (instancetype)initWithContentProvider:(id<TECContentProviderProtocol>)contentProvider
                         collectionView:(UICollectionView *)collectionView
                              extenders:(NSArray<TECCollectionViewExtender *> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy {
    self = [super init];
    if(self) {
        self.collectionView = collectionView;
        self.contentProvider = contentProvider;
        self.delegateProxy = delegateProxy;
        self.extenders = extenders;
        
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupExtenders];
    [self setupCollectionView];
    [self setupContentProvider];
}

- (void)setupContentProvider {
    self.contentProvider.presentationAdapter = self;
}

- (void)setupExtenders {
    for(TECCollectionViewExtender *extender in self.extenders) {
        [self attachExtender:extender];
    }
}

- (void)attachExtender:(TECCollectionViewExtender *)extender {
    extender.contentProvider = self.contentProvider;
    extender.collectionView = self.collectionView;
    [self.delegateProxy attachDelegate:extender];
}

- (void)setupCollectionView {
    self.collectionView.delegate = [self.delegateProxy proxy];
    self.collectionView.dataSource = [self.delegateProxy proxy];
}

#pragma mark - ContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [self.collectionView reloadData];
}

@end
