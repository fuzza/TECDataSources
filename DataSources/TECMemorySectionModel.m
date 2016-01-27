//
//  TECMemorySectionModel.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECMemorySectionModel.h"

@interface TECMemorySectionModel ()

@property (nonatomic, strong, readwrite) NSArray *items;
@property (nonatomic, strong, readwrite) NSString *headerTitle;
@property (nonatomic, strong, readwrite) NSString *footerTitle;

@end

@implementation TECMemorySectionModel

#pragma mark - Initializers

- (instancetype)initWithItems:(NSArray *)items {
    return [self initWithItems:items
                   headerTitle:nil
                   footerTitle:nil];
}

- (instancetype)initWithItems:(NSArray *)items
                  headerTitle:(NSString *)headerTitle
                  footerTitle:(NSString *)footerTitle {
    self = [super init];
    if(self) {
        self.items = items;
        self.headerTitle = headerTitle;
        self.footerTitle = footerTitle;
    }
    return self;
}

#pragma mark - Mutating items

- (void)replaceItems:(NSArray *)items {
    self.items = items;
}

@end
