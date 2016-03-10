//
//  BaseTableContentProviderViewController.h
//  DataSources
//
//  Created by Petro Korienev on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TECTableViewPresentationAdapter.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"
#import "TECTableViewEditingExtender.h"
#import "TECTableViewReorderingExtender.h"
#import "TECTableViewDeletingExtender.h"

@interface BaseTableContentProviderViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) UIBarButtonItem *reloadButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;

@property (nonatomic, strong) TECTableViewPresentationAdapter *tableController;

@property (nonatomic, strong) TECTableViewSectionHeaderExtender *headerExtender;
@property (nonatomic, strong) TECTableViewSectionFooterExtender *footerExtender;
@property (nonatomic, strong) TECTableViewCellExtender *cellExtender;
@property (nonatomic, strong) TECTableViewReorderingExtender *reorderingExtender;
@property (nonatomic, strong) TECTableViewEditingExtender *editingExtender;
@property (nonatomic, strong) TECTableViewDeletingExtender *deletingExtender;

- (id<TECContentProviderProtocol>)contentProvider;

- (void)setupTableController;
- (void)setupSubviews;
- (void)setupToolbar;

- (void)closeButtonPressed:(id)sender;

@end
