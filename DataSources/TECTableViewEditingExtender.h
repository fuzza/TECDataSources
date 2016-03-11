//
//  TECTableViewEditingExtender.h
//  DataSources
//
//  Created by Petro Korienev on 2/3/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewExtender.h"

@protocol TECSectionModelProtocol;

typedef BOOL(^TECTableViewEditingExtenderCanEditBlock)(UITableView *tableView,
                                                       NSIndexPath *indexPath,
                                                       id <TECSectionModelProtocol> section,
                                                       id item);

@interface TECTableViewEditingExtender : TECTableViewExtender

+ (instancetype)editingExtenderWithCanEditBlock:(TECTableViewEditingExtenderCanEditBlock)block;
- (instancetype)initWithCanEditBlock:(TECTableViewEditingExtenderCanEditBlock)block;
- (void)setEditing:(BOOL)editing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (BOOL)isEditing;

@end
