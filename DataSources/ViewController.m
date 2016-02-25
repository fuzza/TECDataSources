//
//  ViewController.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "ViewController.h"
#import "TECTableController.h"

#import "TECTableViewCellRegistrationAdapter.h"
#import "TECSimpleReusableViewFactory.h"

#import "TECMemoryContentProvider.h"
#import "TECMemorySectionModel.h"

#import "TECCustomCell.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"
#import "TECTableViewEditingExtender.h"
#import "TECTableViewReorderingExtender.h"
#import "TECTableViewDeletingExtender.h"

#import "TECDelegateProxy.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) UIBarButtonItem *reloadButtonItem;

@property (nonatomic, strong) TECTableController *tableController;

@property (nonatomic, strong) TECTableViewSectionHeaderExtender *headerExtender;
@property (nonatomic, strong) TECTableViewSectionFooterExtender *footerExtender;
@property (nonatomic, strong) TECTableViewCellExtender *cellExtender;
@property (nonatomic, strong) TECTableViewReorderingExtender *reorderingExtender;
@property (nonatomic, strong) TECTableViewEditingExtender *editingExtender;
@property (nonatomic, strong) TECTableViewDeletingExtender *deletingExtender;

@property (nonatomic, strong) TECMemoryContentProvider *contentProvider;

@end

@implementation ViewController

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
    self.reloadButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:@selector(reloadButtonPressed:)];
    self.toolbar.items = @[self.editBarButtonItem, self.flexibleSpace, self.reloadButtonItem];
    [self.view addSubview:self.toolbar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.toolbar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
}

- (void)setupTableController {
    TECTableViewCellRegistrationAdapter *cellAdapter = [[TECTableViewCellRegistrationAdapter alloc] initWithTableView:self.tableView];
    
    TECSimpleReusableViewFactory <TECCustomCell *, NSString *> *cellFactory = [[TECSimpleReusableViewFactory alloc] initWithRegistrationAdapter:cellAdapter];
    [cellFactory registerViewClass:[TECCustomCell class]];
    [cellFactory setConfigurationHandler:^(TECCustomCell *cell, NSString *object, NSIndexPath *indexPath) {
        cell.textLabel.text = object;
    }];
    
    TECMemorySectionModel *firstSection = [[TECMemorySectionModel alloc] initWithItems:@[@"one", @"two", @"three"] headerTitle:@"firstHeader" footerTitle:@"firstFooter"];
    TECMemorySectionModel *secondSection = [[TECMemorySectionModel alloc] initWithItems:@[@"four", @"five", @"six"] headerTitle:@"secondHeader" footerTitle:@"secondFooter"];
    self.contentProvider = [[TECMemoryContentProvider alloc] initWithSections:@[firstSection, secondSection]];

    self.footerExtender = [TECTableViewSectionFooterExtender extender];
    self.headerExtender = [TECTableViewSectionHeaderExtender extender];
    
    self.cellExtender = [TECTableViewCellExtender cellExtenderWithCellFactory:cellFactory];
    self.reorderingExtender =
    [TECTableViewReorderingExtender reorderingExtenderWithCanMoveBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    } targetIndexPathBlock:^NSIndexPath *(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item, NSIndexPath *targetIndexPath, id<TECSectionModelProtocol> targetSection, id targetItem) {
        NSIndexPath *result = targetIndexPath;
        if (indexPath.section == 0 || targetIndexPath.section == 0) { // Disable reorder from and to first section, enable from others
            result = indexPath;
        }
        return result;
    }];
    self.editingExtender = [TECTableViewEditingExtender editingExtenderWithCanEditBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    }];
    self.deletingExtender = [TECTableViewDeletingExtender extender];
   
// Table controller may be initialized with set of extenders, table view and content provider
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
                             self.reloadButtonItem] animated:YES];
}

- (void)doneButtonPressed:(id)sender {
    [self.editingExtender setEditing:NO animated:YES];
    [self.toolbar setItems:@[self.editBarButtonItem,
                             self.flexibleSpace,
                             self.reloadButtonItem] animated:YES];
}

- (void)reloadButtonPressed:(id)sender {
    [self.contentProvider reloadDataSourceWithCompletion:nil];
}

@end
