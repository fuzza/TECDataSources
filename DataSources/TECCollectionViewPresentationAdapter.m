//
//  TECCollectionController.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewPresentationAdapter.h"
#import "TECContentProviderProtocol.h"
#import "TECCollectionViewExtender.h"
#import "TECDelegateProxy.h"
#import "TECBlockOperation.h"

@interface TECCollectionViewPresentationAdapter ()

@property (nonatomic, strong, readwrite) UICollectionView *extendedView;
@property (nonatomic, strong) id <TECContentProviderProtocol> contentProvider;
@property (nonatomic, strong) TECDelegateProxy *delegateProxy;
@property (nonatomic, strong) TECBlockOperation *blockOperation;

@end

@implementation TECCollectionViewPresentationAdapter

- (instancetype)initWithContentProvider:(id<TECContentProviderProtocol>)contentProvider
                         collectionView:(UICollectionView *)collectionView
                              extenders:(NSArray<TECCollectionViewExtender *> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy {
    self = [super init];
    if(self) {
        
        self.extendedView = collectionView;
        self.contentProvider = contentProvider;
        self.delegateProxy = delegateProxy;
        [self addExtenders:extenders];
        [self setupContentProvider];
    }
    return self;
}

- (void)setupContentProvider {
    self.contentProvider.presentationAdapter = self;
}

- (void)addExtenders:(NSArray *)extenders {
    for(TECCollectionViewExtender *extender in extenders) {
        [self attachExtender:extender];
    }
    [self setupExtendedView];
}

- (void)attachExtender:(TECCollectionViewExtender *)extender {
    extender.contentProvider = self.contentProvider;
    extender.extendedView = self.extendedView;
    [self.delegateProxy attachDelegate:extender];
}

- (void)setupExtendedView {
    self.extendedView.delegate = [self.delegateProxy proxy];
    self.extendedView.dataSource = [self.delegateProxy proxy];
}

#pragma mark - TECContentProviderPresentationAdapterProtocol

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView reloadData];
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
                [weakSelf.extendedView insertSections:[NSIndexSet indexSetWithIndex:index]];
            }];
            break;
        }
        case TECContentProviderSectionChangeTypeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.extendedView deleteSections:[NSIndexSet indexSetWithIndex:index]];
            }];
            break;
        }
        case TECContentProviderSectionChangeTypeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.extendedView reloadSections:[NSIndexSet indexSetWithIndex:index]];
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
                [weakSelf.extendedView insertItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        case TECContentProviderItemChangeTypeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.extendedView deleteItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        case TECContentProviderItemChangeTypeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.extendedView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        case TECContentProviderItemChangeTypeMove: {
            [self.blockOperation addExecutionBlock:^{
                [weakSelf.extendedView deleteItemsAtIndexPaths:@[indexPath]];
                [weakSelf.extendedView insertItemsAtIndexPaths:@[newIndexPath]];
            }];
            break;
        }
    }
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    __weak typeof(self) weakSelf = self;
    [self.extendedView performBatchUpdates:^{
        [weakSelf.blockOperation start];
    } completion:nil];
}

@end
