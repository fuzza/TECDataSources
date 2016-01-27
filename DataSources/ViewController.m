//
//  ViewController.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "ViewController.h"
#import "TECTableController.h"

#import "TECMemoryContentProvider.h"
#import "TECMemorySectionModel.h"

#import "TECTableViewCellFactory.h"
#import "TECTableViewCellRegistrator.h"

#import "TECCustomCell.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TECTableController *tableController;

@property (nonatomic, strong) TECTableViewSectionHeaderExtender *headerExtender;
@property (nonatomic, strong) TECTableViewSectionFooterExtender *footerExtender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self setupTableController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)setupTableController {
    TECTableViewCellRegistrator *registrator = [[TECTableViewCellRegistrator alloc] initWithClassHandler:^Class(id item, NSIndexPath *indexPath) {
        return [TECCustomCell class];
    } reuseIdHandler:^NSString *(Class cellClass, id item, NSIndexPath *indexPath) {
        return NSStringFromClass(cellClass);
    }];
    
    TECTableViewCellFactory *factory = [[TECTableViewCellFactory alloc] initWithСellRegistrator:registrator
            configurationHandler:^UITableViewCell *(UITableViewCell *cell, id item, UITableView *tableView, NSIndexPath *indexPath) {
                return cell;
    }];
    
    TECMemorySectionModel *firstSection = [[TECMemorySectionModel alloc] initWithItems:@[@"one", @"two", @"three"] headerTitle:@"firstHeader" footerTitle:@"firstFooter"];
    TECMemorySectionModel *secondSection = [[TECMemorySectionModel alloc] initWithItems:@[@"four", @"five", @"six"] headerTitle:@"secondHeader" footerTitle:@"secondFooter"];
    TECMemoryContentProvider *contentProvider = [[TECMemoryContentProvider alloc] initWithSections:@[firstSection, secondSection]];
    
    self.tableController = [[TECTableController alloc] initWithContentProvider:contentProvider
                                                                   cellFactory:factory];

    self.footerExtender = [[TECTableViewSectionFooterExtender alloc] init];
    self.headerExtender = [[TECTableViewSectionHeaderExtender alloc] init];
    
    TECTableViewCellExtender *cellExtender = [[TECTableViewCellExtender alloc] init];
    
    [self.tableController addExtenders:@[
                                        self.headerExtender,
                                        self.footerExtender,
                                        cellExtender]];
    
    [self.tableController setupWithTableView:self.tableView];
    [self.tableController reloadDataSourceWithCompletion:nil];
}

@end
