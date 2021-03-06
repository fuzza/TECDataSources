//
//  FetchedResultsContentProviderSearchViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultsContentProviderSearchViewController.h"
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

@interface FetchedResultsContentProviderSearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@end

@implementation FetchedResultsContentProviderSearchViewController

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

- (void)setupSubviews {
    [super setupSubviews];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.toolbar.frame),
                                                                   self.view.frame.size.width,
                                                                   30.0f)];
    self.searchBar.placeholder = @"Enter search term";
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.searchBar.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.toolbar.frame),
                                      self.view.frame.size.width,
                                      30.0f);
    self.tableView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.searchBar.frame),
                                      self.view.frame.size.width,
                                      self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame));
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self doSearchWithText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    [self doSearchWithText:nil];
}

- (void)doSearchWithText:(NSString *)searchText {
    NSFetchRequest *fetchRequest = self.contentProvider.currentRequest;
    if (searchText.length) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText];
    }
    else {
        fetchRequest.predicate = nil;
    }
    self.contentProvider.currentRequest = fetchRequest;
}

@end
