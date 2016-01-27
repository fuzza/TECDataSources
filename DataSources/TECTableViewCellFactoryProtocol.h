//
//  TECTableViewCellFactoryProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECTableViewCellFactoryProtocol <NSObject>

- (UITableViewCell *)cellForItem:(id)item
                       tableView:(UITableView *)tableView
                     atIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)configureCell:(UITableViewCell *)cell
                           forItem:(id)item inTableView:(UITableView *)tableView
                       atIndexPath:(NSIndexPath *)indexPath;

@end
