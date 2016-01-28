//
//  TECTableViewCellFactory.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewCellFactory.h"
#import "TECTableViewCellRegistratorProtocol.h"

@interface TECTableViewCellFactory ()

@property (nonatomic, strong) id <TECTableViewCellRegistratorProtocol> cellRegistrator;
@property (nonatomic, copy) TECTableViewCellConfigurationHandler configurationHandler;

@end

@implementation TECTableViewCellFactory

- (instancetype)initWithСellRegistrator:(id <TECTableViewCellRegistratorProtocol>)cellRegistrator
                   configurationHandler:(TECTableViewCellConfigurationHandler)handler; {
    self = [super init];
    if(self) {
        NSParameterAssert(cellRegistrator);
        self.cellRegistrator = cellRegistrator;
        self.configurationHandler = handler;
    }
    return self;
}

- (UITableViewCell *)cellForItem:(id)item
                       tableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [self.cellRegistrator cellReuseIdentifierForItem:item tableView:tableView atIndexPath:indexPath];
    NSParameterAssert(reuseIdentifier);
    return [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (UITableViewCell *)configureCell:(UITableViewCell *)cell forItem:(id)item inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if(self.configurationHandler) {
        return self.configurationHandler(cell, item, tableView, indexPath);
    }
    return cell;
}

@end
