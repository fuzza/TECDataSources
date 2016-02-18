//
//  TECTableViewSectionHeaderExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewSectionHeaderExtender.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"

TECTableViewExtenderImplementation(TECTableViewSectionHeaderExtender)

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <TECSectionModelProtocol> sectionModel = [self.contentProvider sectionAtIndex:section];
    return sectionModel.headerTitle;
}

TECTableViewExtenderEnd
