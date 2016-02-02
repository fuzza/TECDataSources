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

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.items[idx];
}

#pragma mark - Mutating items

- (void)replaceItems:(NSArray *)items {
    self.items = items;
}

#pragma mark - NSFastEnumeration implementation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    return [self.items countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count {
    return self.items.count;
}

@end
