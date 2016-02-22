//
//  ViewController.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "MemoryContentProviderViewController.h"

#import "TECMemoryContentProvider.h"
#import "TECMemorySectionModel.h"

#import "TECTableViewCellFactory.h"
#import "TECTableViewCellRegistrator.h"

#import "TECCustomCell.h"

#import "TECDelegateProxy.h"

@interface MemoryContentProviderViewController ()

@property (nonatomic, strong, readwrite) TECMemoryContentProvider *contentProvider;

@end

@implementation MemoryContentProviderViewController

- (void)setupTableController {
    TECTableViewCellRegistrator *registrator = [[TECTableViewCellRegistrator alloc] initWithClassHandler:^Class(id item, NSIndexPath *indexPath) {
        return [TECCustomCell class];
    } reuseIdHandler:^NSString *(Class cellClass, id item, NSIndexPath *indexPath) {
        return NSStringFromClass(cellClass);
    }];
    
    TECTableViewCellFactory *factory = [[TECTableViewCellFactory alloc] initWithСellRegistrator:registrator
            configurationHandler:^(UITableViewCell *cell, id item, UITableView *tableView, NSIndexPath *indexPath) {
                cell.textLabel.text = item;
    }];
    
    TECMemorySectionModel *firstSection = [[TECMemorySectionModel alloc] initWithItems:@[@"one", @"two", @"three"] headerTitle:@"firstHeader" footerTitle:@"firstFooter"];
    TECMemorySectionModel *secondSection = [[TECMemorySectionModel alloc] initWithItems:@[@"four", @"five", @"six"] headerTitle:@"secondHeader" footerTitle:@"secondFooter"];
    self.contentProvider = [[TECMemoryContentProvider alloc] initWithSections:@[firstSection, secondSection]];
    
    self.footerExtender = [TECTableViewSectionFooterExtender extender];
    self.headerExtender = [TECTableViewSectionHeaderExtender extender];
    
    self.cellExtender = [TECTableViewCellExtender cellExtenderWithCellFactory:factory];
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
