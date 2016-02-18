//
//  TECTableViewReorderingExtender.h
//  DataSources
//
//  Created by Petro Korienev on 2/4/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewExtender.h"

@protocol TECSectionModelProtocol;

typedef BOOL(^TECTableViewReorderingExtenderCanMoveBlock)(UITableView *tableView,
                                                          NSIndexPath *indexPath,
                                                          id <TECSectionModelProtocol> section,
                                                          id item);
typedef NSIndexPath *(^TECTableViewReorderingExtenderTargetIndexPathBlock)(UITableView *tableView,
                                                                         NSIndexPath *indexPath,
                                                                         id <TECSectionModelProtocol> section,
                                                                         id item,
                                                                         NSIndexPath *targetIndexPath,
                                                                         id <TECSectionModelProtocol> targetSection,
                                                                         id targetItem);

TECTableViewExtenderInterface(TECTableViewReorderingExtender)

+ (instancetype)reorderingExtenderWithCanMoveBlock:(TECTableViewReorderingExtenderCanMoveBlock)canMoveBlock
                              targetIndexPathBlock:(TECTableViewReorderingExtenderTargetIndexPathBlock)targetIndexPathBlock;
- (instancetype)initWithCanMoveBlock:(TECTableViewReorderingExtenderCanMoveBlock)canMoveBlock
                targetIndexPathBlock:(TECTableViewReorderingExtenderTargetIndexPathBlock)targetIndexPathBlock;

TECTableViewExtenderEnd
