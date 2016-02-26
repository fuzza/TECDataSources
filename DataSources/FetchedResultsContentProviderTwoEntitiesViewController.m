//
//  FetchedResultsContentProviderTwoEntitiesViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultsContentProviderTwoEntitiesViewController.h"

#import "TECTableController.h"

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
#import "PersonOrdered.h"

@interface FetchedResultsContentProviderTwoEntitiesViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@property (nonatomic, strong) NSFetchRequest *personFetchRequest;
@property (nonatomic, strong) NSFetchRequest *personOrderedFetchRequest;

@end

@implementation FetchedResultsContentProviderTwoEntitiesViewController

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
    
    self.personFetchRequest = [[CoreDataManager sharedObject] createPersonFetchRequest];
    self.personOrderedFetchRequest = [[CoreDataManager sharedObject] createPersonOrderedFetchRequest];
    
    self.contentProvider =
    [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:[[CoreDataManager sharedObject] createObjectGetter]
                                                               itemsMutator:[[CoreDataManager sharedObject] createObjectMutator]
                                                               fetchRequest:self.personFetchRequest
                                                         sectionNameKeyPath:@"firstAlphaCapitalized"];
    
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

- (void)setupSubviews {
    [super setupSubviews];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.toolbar.frame),
                                                                   self.view.frame.size.width,
                                                                   30.0f)];
    self.searchBar.placeholder = @"Enter search term";
    self.searchBar.showsCancelButton = YES;
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[NSStringFromClass([Person class]),
                                         NSStringFromClass([PersonOrdered class])];    
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.searchBar sizeToFit];
    self.searchBar.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.toolbar.frame),
                                      self.view.frame.size.width,
                                      self.searchBar.frame.size.height);
    self.tableView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.searchBar.frame),
                                      self.view.frame.size.width,
                                      self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame));
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self doSearchWithText:searchText scope:self.searchBar.selectedScopeButtonIndex];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    [self doSearchWithText:nil scope:self.searchBar.selectedScopeButtonIndex];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self doSearchWithText:searchBar.text scope:selectedScope];
}

- (void)doSearchWithText:(NSString *)searchText scope:(NSInteger)scope {
    NSPredicate *searchPredicate = nil;
    if (searchText.length) {
        searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText];
    }
    self.personFetchRequest.predicate = searchPredicate;
    self.personOrderedFetchRequest.predicate = searchPredicate;
    self.contentProvider.currentRequest = scope ? self.personOrderedFetchRequest : self.personFetchRequest;
}

@end
