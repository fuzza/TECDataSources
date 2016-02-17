//
//  TECCoreDataSection.m
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCoreDataSectionModel.h"
#import <libkern/OSAtomic.h>

@interface TECCoreDataSectionModel ()

@property (nonatomic, strong) id <NSFetchedResultsSectionInfo> info;
@property (nonatomic, copy) NSString *footerTitle;

@end

@implementation TECCoreDataSectionModel

- (instancetype)initWithFetchedResultsSectionInfo:(id<NSFetchedResultsSectionInfo>)info  {
    self = [self init];
    if (self) {
        self.info = info;
    }
    return self;
}

- (NSString *)headerTitle {
    return self.info.name;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    NSAssert(NO, @"%s CoreData section asked for ineligible mutation", __PRETTY_FUNCTION__);
}

#pragma mark - NSFastEnumeration implementation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id  _Nonnull *)buffer
                                    count:(NSUInteger)len {
    return [self.info.objects countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count {
    return self.info.numberOfObjects;
}

- (NSEnumerator *)objectEnumerator {
    return [self.info.objects objectEnumerator];
}

- (NSEnumerator *)reverseObjectEnumerator {
    return [self.info.objects reverseObjectEnumerator];
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

- (NSManagedObject *)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.info.objects[idx];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx {
    NSAssert(NO, @"%s CoreData section asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (void)insertItem:(id)object atIndex:(NSUInteger)idx {
    NSAssert(NO, @"%s CoreData section asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (void)removeItemAtIndex:(NSUInteger)idx {
    NSAssert(NO, @"%s CoreData section asked for ineligible mutation", __PRETTY_FUNCTION__);
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
        result = [self.info.objects isEqualToArray:((TECCoreDataSectionModel *)object).info.objects] &&
        ([self.headerTitle isEqualToString:[object headerTitle]] || ([self headerTitle] == nil && [object headerTitle] == nil)) &&
        ([self.footerTitle isEqualToString:[object footerTitle]] || ([self footerTitle] == nil && [object footerTitle] == nil));
    }
    return result;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    typeof(self) copy = [[[self class] alloc] initWithFetchedResultsSectionInfo:self.info];
    copy.footerTitle = self.footerTitle;
    return copy;
}

@end
