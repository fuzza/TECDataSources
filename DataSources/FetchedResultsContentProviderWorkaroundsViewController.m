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

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) UIBarButtonItem *reloadButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

@property (nonatomic, strong) TECTableController *tableController;

@property (nonatomic, strong) TECTableViewSectionHeaderExtender *headerExtender;
@property (nonatomic, strong) TECTableViewSectionFooterExtender *footerExtender;
@property (nonatomic, strong) TECTableViewCellExtender *cellExtender;
@property (nonatomic, strong) TECTableViewReorderingExtender *reorderingExtender;
@property (nonatomic, strong) TECTableViewEditingExtender *editingExtender;
@property (nonatomic, strong) TECTableViewDeletingExtender *deletingExtender;

@property (nonatomic, strong) TECMainContextObjectGetter *objectGetter;
@property (nonatomic, strong) TECBackgroundContextObjectMutator *objectMutator;

@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@end

@implementation FetchedResultsContentProviderWorkaroundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupTableController];
}

- (void)setupSubviews {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.toolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    self.editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.reloadButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadButtonPressed:)];
    self.closeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonPressed:)];
    self.toolbar.items = @[self.editBarButtonItem, self.flexibleSpace, self.reloadButtonItem, self.closeButtonItem];
    [self.view addSubview:self.toolbar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.toolbar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
}

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
    
    NSFetchRequest *fetchRequest = [[CoreDataManager sharedObject] createPersonOrderedFetchRequest];
    
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

- (void)editButtonPressed:(id)sender {
    [self.editingExtender setEditing:YES animated:YES];
    [self.toolbar setItems:@[self.doneBarButtonItem,
                             self.flexibleSpace,
                             self.reloadButtonItem,
                             self.closeButtonItem] animated:YES];
}

- (void)doneButtonPressed:(id)sender {
    [self.editingExtender setEditing:NO animated:YES];
    [self.toolbar setItems:@[self.editBarButtonItem,
                             self.flexibleSpace,
                             self.reloadButtonItem,
                             self.closeButtonItem] animated:YES];
}

- (void)reloadButtonPressed:(id)sender {
    [self.contentProvider reloadDataSourceWithCompletion:nil];
}

- (void)closeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"backToRootViewControllerWithSegue" sender:sender];
}

@end
