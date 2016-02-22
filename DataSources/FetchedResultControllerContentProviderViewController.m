//
//  FetchedResultControllerContentProviderViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultControllerContentProviderViewController.h"
#import "TECTableController.h"

#import "TECFetchedResultsControllerContentProvider.h"

#import "TECTableViewCellFactory.h"
#import "TECTableViewCellRegistrator.h"

#import "TECCustomCell.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"
#import "TECTableViewEditingExtender.h"
#import "TECTableViewDeletingExtender.h"

#import "TECDelegateProxy.h"
#import "CoreDataManager.h"

@interface FetchedResultControllerContentProviderViewController ()

@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@end

@implementation FetchedResultControllerContentProviderViewController

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
    self.editingExtender = [TECTableViewEditingExtender editingExtenderWithCanEditBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    }];
    self.deletingExtender = [TECTableViewDeletingExtender extender];
    
    self.contentProvider =
    [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:[[CoreDataManager sharedObject] createObjectGetter]
                                                               itemsMutator:[[CoreDataManager sharedObject] createObjectMutator] fetchRequest:[[CoreDataManager sharedObject] createPersonFetchRequest] sectionNameKeyPath:@"firstAlphaCapitalized"];
    
    self.tableController =
    [[TECTableController alloc] initWithContentProvider:self.contentProvider
                                              tableView:self.tableView
                                              extenders:@[
                                                          self.headerExtender,
                                                          self.footerExtender,
                                                          self.cellExtender,
                                                          self.editingExtender,
                                                          self.deletingExtender]
                                          delegateProxy:[[TECDelegateProxy alloc] init]];
}

@end
