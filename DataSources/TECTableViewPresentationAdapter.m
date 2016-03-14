//
//  TECTableViewDataSource.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewPresentationAdapter.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"

#import "TECDelegateProxy.h"
#import "TECTableViewExtender.h"

@interface TECTableViewPresentationAdapter ()

@property (nonatomic, strong, readwrite) UITableView *extendedView;

@property (nonatomic, strong, readwrite) id <TECContentProviderProtocol> contentProvider;

@property (nonatomic, strong) TECDelegateProxy <id <UITableViewDelegate, UITableViewDataSource>> *delegateProxy;

@end

@implementation TECTableViewPresentationAdapter

@synthesize extendedView;
@synthesize contentProvider;

#pragma mark - ContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView reloadData];
}

- (void)contentProviderWillChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView beginUpdates];
}

- (void)contentProviderDidChangeItem:(id)item
                         atIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)newIndexPath {
    switch (changeType) {
        case TECContentProviderItemChangeTypeDelete:
            [self.extendedView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderItemChangeTypeInsert:
            [self.extendedView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderItemChangeTypeMove:
            [self.extendedView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case TECContentProviderItemChangeTypeUpdate:
            [self.extendedView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)contentProviderDidChangeSection:(id<TECSectionModelProtocol>)section
                                atIndex:(NSUInteger)index
                          forChangeType:(TECContentProviderSectionChangeType)changeType {
    switch (changeType) {
        case TECContentProviderSectionChangeTypeInsert:
            [self.extendedView insertSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderSectionChangeTypeDelete:
            [self.extendedView deleteSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderSectionChangeTypeUpdate:
            [self.extendedView reloadSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView endUpdates];
}

@end
