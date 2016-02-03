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

@property (nonatomic, copy, readwrite) NSArray *items;
@property (nonatomic, copy, readwrite) NSString *headerTitle;
@property (nonatomic, copy, readwrite) NSString *footerTitle;

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
                                  objects:(__unsafe_unretained id  _Nonnull *)buffer
                                    count:(NSUInteger)len {
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
    BOOL isEnumerationConcurrent = options & NSEnumerationConcurrent;
    BOOL isEnumerationReverse = options & NSEnumerationReverse;
    NSEnumerator *enumerator = isEnumerationReverse ? [self reverseObjectEnumerator] : [self objectEnumerator];
    for (id object in enumerator) {
        void(^innerBlock)() = ^() {
            block(object, idx, &stop);
            
            OSAtomicIncrement32(&idx);
        };
        if (isEnumerationConcurrent) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), innerBlock);
        }
        else {
            innerBlock();
        }
        if (stop) {
            return;
        }
    }
}

#pragma mark - NSCopying implementation

- (NSUInteger)hash {
    NSUInteger hash = 0;
    for(id object in self) {
        hash += [object hash];
    }
    return hash + self.headerTitle.hash + self.footerTitle.hash;
}

- (BOOL)isEqual:(id)object {
    BOOL result = NO;
    if ([object isKindOfClass:[self class]] || [self isKindOfClass:[object class]]) {
        result = [[self items] isEqualToArray:[object items]] &&
                 ([self.headerTitle isEqualToString:[object headerTitle]] || ([self headerTitle] == nil && [object headerTitle] == nil)) &&
                 ([self.footerTitle isEqualToString:[object footerTitle]] || ([self footerTitle] == nil && [object footerTitle] == nil));
    }
    return result;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithItems:self.items
                                   headerTitle:self.headerTitle
                                   footerTitle:self.footerTitle];
}

@end
