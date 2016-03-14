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
@property (nonatomic, strong, readwrite) id <TECContentProviderProtocol> contentProvider;
@property (nonatomic, strong) TECDelegateProxy *delegateProxy;
@property (nonatomic, strong) TECBlockOperation *blockOperation;

@end

@implementation TECCollectionViewPresentationAdapter

@synthesize extendedView;
@synthesize contentProvider;

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

- (void)contentProviderDidChangeItem:(id)item
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
