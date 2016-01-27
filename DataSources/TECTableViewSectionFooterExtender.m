//
//  TECTableViewSectionFooterExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewSectionFooterExtender.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"

@implementation TECTableViewSectionFooterExtender

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    id <TECSectionModelProtocol> sectionModel = [self.contentProvider sectionAtIndex:section];
    return sectionModel.footerTitle;
}

@end
