//
//  TECTableViewCellFactory.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECTableViewCellFactoryProtocol.h"

@protocol TECTableViewCellRegistratorProtocol;

@interface TECTableViewCellFactory <__covariant CellType: UITableViewCell *, ObjectType> : NSObject <TECTableViewCellFactoryProtocol>

typedef void(^TECTableViewCellConfigurationHandler)(CellType cell, ObjectType item, UITableView *tableView, NSIndexPath *indexPath);

- (instancetype)initWithСellRegistrator:(id <TECTableViewCellRegistratorProtocol>)cellRegistrator
                   configurationHandler:(TECTableViewCellConfigurationHandler)handler;

- (CellType)cellForItem:(ObjectType)item
              tableView:(UITableView *)tableView
            atIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(CellType)cell
              forItem:(ObjectType)item
          inTableView:(UITableView *)tableView
          atIndexPath:(NSIndexPath *)indexPath;

@end
