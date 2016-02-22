//
//  BaseTableContentProviderViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "BaseTableContentProviderViewController.h"
#import "TECContentProviderProtocol.h"

@interface BaseTableContentProviderViewController ()

@end

@implementation BaseTableContentProviderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupTableController];
}

- (void)setupToolbar {
    self.toolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    self.editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.reloadButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadButtonPressed:)];
    self.closeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonPressed:)];
    self.toolbar.items = @[self.editBarButtonItem, self.flexibleSpace, self.reloadButtonItem, self.closeButtonItem];
    [self.view addSubview:self.toolbar];
}

- (void)setupSubviews {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self setupToolbar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.toolbar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
}

- (id <TECContentProviderProtocol>)contentProvider {
    NSAssert(NO, @"Abstract implementation");
    return nil;
}

- (void)setupTableController {
    NSAssert(NO, @"Abstract implementation");
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
