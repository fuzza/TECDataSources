//
//  TECTableViewHeaderFooterViewRegistrationAdapter.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/24/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewHeaderFooterViewRegistrationAdapter.h"

@interface TECTableViewHeaderFooterViewRegistrationAdapter ()

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TECTableViewHeaderFooterViewRegistrationAdapter

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if(self) {
        self.tableView = tableView;
    }
    return self;
}

#pragma mark TECReusableViewRegistrationAdapterProtocol

- (void)registerClass:(Class)aClass forReuseIdentifier:(NSString *)reuseIdentifier {
    NSAssert([aClass isSubclassOfClass:[UITableViewHeaderFooterView class]], @"Class should be UITableViewHeaderFooter subclass");
    NSParameterAssert(reuseIdentifier);
    [self.tableView registerClass:aClass forHeaderFooterViewReuseIdentifier:reuseIdentifier];
}

- (UITableViewHeaderFooterView *)reuseViewWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(identifier);
    return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

@end
