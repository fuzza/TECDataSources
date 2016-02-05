//
//  TECTableViewDeletingExtender.m
//  DataSources
//
//  Created by Petro Korienev on 2/3/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewDeletingExtender.h"
#import "TECContentProviderProtocol.h"

@implementation TECTableViewDeletingExtender

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.contentProvider deleteItemAtIndexPath:indexPath];
    }
}

@end
