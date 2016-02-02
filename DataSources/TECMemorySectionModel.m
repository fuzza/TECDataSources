//
//  TECMemorySectionModel.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECMemorySectionModel.h"
#import <libkern/OSAtomic.h>

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

- (NSEnumerator *)objectEnumerator {
    return [self.items objectEnumerator];
}

- (NSEnumerator *)reverseObjectEnumerator {
    return [self.items reverseObjectEnumerator];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    [self enumerateObjectsUsingBlock:block options:0];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
                           options:(NSEnumerationOptions)options {
    __block volatile int32_t idx = 0;
    __block BOOL stop = NO;
    for (id object in (options & NSEnumerationReverse) ? [self reverseObjectEnumerator] : [self objectEnumerator] ) {
        void(^innerBlock)() = ^() {
            block(object, idx, &stop);
            OSAtomicIncrement32(&idx);
        };
        if (options & NSEnumerationConcurrent) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), innerBlock);
        }
        else {
            innerBlock();
        }
        if (stop) {
            return;
        }
    }
}

@end
