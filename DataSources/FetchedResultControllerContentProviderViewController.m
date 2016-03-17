//
//  FetchedResultControllerContentProviderViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultControllerContentProviderViewController.h"
#import "TECTableViewPresentationAdapter.h"

#import "TECFetchedResultsControllerContentProvider.h"

#import "TECTableViewCellRegistrationAdapter.h"
#import "TECSimpleReusableViewFactory.h"

#import "TECCustomCell.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"
#import "TECTableViewEditingExtender.h"
#import "TECTableViewDeletingExtender.h"

#import "TECDelegateProxy.h"
#import "CoreDataManager.h"

#import "Person.h"

@interface FetchedResultControllerContentProviderViewController ()

@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@end

@implementation FetchedResultControllerContentProviderViewController

- (void)setupTableController {
    TECTableViewCellRegistrationAdapter *adapter
    = [[TECTableViewCellRegistrationAdapter alloc] initWithTableView:self.tableView];
    
    TECSimpleReusableViewFactory<TECCustomCell *, Person *> *factory = [[TECSimpleReusableViewFactory alloc] initWithRegistrationAdapter:adapter];
    [factory registerViewClass:[TECCustomCell class]];
    [factory setConfigurationHandler:^(TECCustomCell *cell, Person *person, NSIndexPath *indexPath) {
        cell.textLabel.text = person.name;
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
                                                               itemsMutator:[[CoreDataManager sharedObject] createObjectMutator]
                                                               fetchRequest:[[CoreDataManager sharedObject] createPersonFetchRequest]
                                                         sectionNameKeyPath:@"firstAlphaCapitalized"];
    
    self.tableController =
    [[TECTableViewPresentationAdapter alloc] initWithContentProvider:self.contentProvider
                                                        extendedView:self.tableView
                                                           extenders:@[
                                                                       self.headerExtender,
                                                                       self.footerExtender,
                                                                       self.cellExtender,
                                                                       self.editingExtender,
                                                                       self.deletingExtender]
                                                       delegateProxy:[[TECDelegateProxy alloc] init]];
}

@end
