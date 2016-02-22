//
//  FetchedResultsContentProviderWorkaroundsViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/20/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultsContentProviderWorkaroundsViewController.h"

#import "TECTableController.h"

#import "TECFetchedResultsControllerContentProvider.h"

#import "TECTableViewCellFactory.h"
#import "TECTableViewCellRegistrator.h"

#import "TECCustomCell.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"
#import "TECTableViewEditingExtender.h"
#import "TECTableViewReorderingExtender.h"
#import "TECTableViewDeletingExtender.h"

#import "TECDelegateProxy.h"
#import "CoreDataManager.h"

#import "TECMainContextObjectGetter.h"
#import "TECBackgroundContextObjectMutator.h"

#import "Person.h"

@interface FetchedResultsContentProviderWorkaroundsViewController ()

@property (nonatomic, strong) TECMainContextObjectGetter *objectGetter;
@property (nonatomic, strong) TECBackgroundContextObjectMutator *objectMutator;

@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@end

@implementation FetchedResultsContentProviderWorkaroundsViewController

- (void)setupTableController {
    TECTableViewCellRegistrator *registrator = [[TECTableViewCellRegistrator alloc] initWithClassHandler:^Class(id item, NSIndexPath *indexPath) {
        return [TECCustomCell class];
    } reuseIdHandler:^NSString *(Class cellClass, id item, NSIndexPath *indexPath) {
        return NSStringFromClass(cellClass);
    }];
    
    TECTableViewCellFactory *factory = [[TECTableViewCellFactory alloc] initWithСellRegistrator:registrator
                                                                           configurationHandler:^(UITableViewCell *cell, id item, UITableView *tableView, NSIndexPath *indexPath) {
                                                                               cell.textLabel.text = [item name];
                                                                           }];
    
    self.footerExtender = [TECTableViewSectionFooterExtender extender];
    self.headerExtender = [TECTableViewSectionHeaderExtender extender];
    
    self.cellExtender = [TECTableViewCellExtender cellExtenderWithCellFactory:factory];
    self.reorderingExtender =
    [TECTableViewReorderingExtender reorderingExtenderWithCanMoveBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    }
                                                  targetIndexPathBlock:nil];
    self.editingExtender = [TECTableViewEditingExtender editingExtenderWithCanEditBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    }];
    self.deletingExtender = [TECTableViewDeletingExtender extender];
    
    self.objectGetter = [[CoreDataManager sharedObject] createObjectGetter];
    self.objectMutator = [[CoreDataManager sharedObject] createObjectMutator];
    
    NSFetchRequest *fetchRequest = [[CoreDataManager sharedObject] createPersonFetchRequest];
    
    self.contentProvider =
    [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:self.objectGetter
                                                               itemsMutator:self.objectMutator
                                                               fetchRequest:fetchRequest
                                                         sectionNameKeyPath:nil];
    
    self.tableController =
    [[TECTableController alloc] initWithContentProvider:self.contentProvider
                                              tableView:self.tableView
                                              extenders:@[
                                                          self.headerExtender,
                                                          self.footerExtender,
                                                          self.cellExtender,
                                                          self.editingExtender,
                                                          self.deletingExtender,
                                                          self.reorderingExtender]
                                          delegateProxy:[[TECDelegateProxy alloc] init]];
}

@end
