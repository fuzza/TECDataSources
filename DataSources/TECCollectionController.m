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
#import "TECBlockOperation.h"

@interface TECCollectionController ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) id <TECContentProviderProtocol> contentProvider;
@property (nonatomic, strong) NSArray <TECCollectionViewExtender *> *extenders;
@property (nonatomic, strong) TECDelegateProxy *delegateProxy;
@property (nonatomic, strong) TECBlockOperation *blockOperation;

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
    extender.extendedView = self.collectionView;
    [self.delegateProxy attachDelegate:extender];
}

- (void)setupCollectionView {
    self.collectionView.delegate = [self.delegateProxy proxy];
    self.collectionView.dataSource = [self.delegateProxy proxy];
}

#pragma mark - TECContentProviderPresentationAdapterProtocol

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [self.collectionView reloadData];
}

- (void)contentProviderWillChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    self.blockOperation = [TECBlockOperation operation];
}

- (void)contentProviderDidChangeSection:(id<TECSectionModelProtocol>)section
                                atIndex:(NSUInteger)index
                          forChangeType:(TECContentProviderSectionChangeType)changeType {
    __weak typeof(self) weakSelf = self;
    switch (changeType) {
        case TECContentProviderSectionChangeTypeInsert: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView insertSections:[NSIndexSet indexSetWithIndex:index]];
            }];
            break;
        }
        case TECContentProviderSectionChangeTypeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView deleteSections:[NSIndexSet indexSetWithIndex:index]];
            }];
            break;
        }
        case TECContentProviderSectionChangeTypeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:index]];
            }];
            break;
        }
    }
}

- (void)contentProviderDidChangeItem:(id<TECSectionModelProtocol>)section
                         atIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)newIndexPath {
    __weak typeof(self) weakSelf = self;
    switch (changeType) {
        case TECContentProviderItemChangeTypeInsert: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView insertItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        case TECContentProviderItemChangeTypeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        case TECContentProviderItemChangeTypeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        case TECContentProviderItemChangeTypeMove: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [weakSelf.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            }];
            break;
        }
    }
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        [weakSelf.blockOperation start];
    } completion:nil];
}

@end
