//
//  TECCellRegistratorProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECTableViewCellRegistratorProtocol <NSObject>

- (NSString *)cellReuseIdentifierForItem:(id)item
                               tableView:(UITableView *)tableView
                             atIndexPath:(NSIndexPath *)indexPath;

- (Class)cellClassForItem:(id)item
                tableView:(UITableView *)tableView
              atIndexPath:(NSIndexPath *)indexPath;

@end
