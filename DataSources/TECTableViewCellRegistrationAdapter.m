//
//  TECTableViewCellRegistrationAdapter.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/24/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewCellRegistrationAdapter.h"

@interface TECTableViewCellRegistrationAdapter ()

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TECTableViewCellRegistrationAdapter

- (instancetype)initWithTableView:(UITableView *)tableView {
    NSParameterAssert(tableView);
    self = [super init];
    if(self) {
        self.tableView = tableView;
    }
    return self;
}

#pragma mark - TECReusableViewRegistrationAdapterProtocol

- (void)registerClass:(Class)aClass forReuseIdentifier:(NSString *)reuseIdentifier {
    NSAssert([aClass isSubclassOfClass:[UITableViewCell class]], @"Class should be UITableViewCell subclass");
    NSParameterAssert(reuseIdentifier);
    [self.tableView registerClass:aClass forCellReuseIdentifier:reuseIdentifier];
}

- (UITableViewCell *)reuseViewWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(identifier);
    NSParameterAssert(indexPath);
    return [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

@end
