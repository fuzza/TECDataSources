//
//  TECMemoryContentProvider.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECMemoryContentProvider.h"
#import "TECContentProviderDelegate.h"
#import <libkern/OSAtomic.h>

@interface TECMemoryContentProvider ()

@property (nonatomic, strong) NSMutableArray<id<TECSectionModelProtocol>> *sections;
@property (nonatomic, assign) BOOL isUpdating;
@property (nonatomic, assign) BOOL isBatchUpdating;

@end

@implementation TECMemoryContentProvider
@synthesize presentationAdapter = _presentationAdapter;

- (instancetype)initWithSections:(NSArray<id<TECSectionModelProtocol>> *)sections {
    self = [super init];
    if(self) {
        self.sections = [sections mutableCopy];
    }
    return self;
}

#pragma mark - TECContentProviderProtocol implementation

- (NSInteger)numberOfSections {
    return self.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.sections[section].count;
}

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)index {
    return self.sections[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section][indexPath.row];
}

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion {
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidReloadData:)]) {
        [self.presentationAdapter contentProviderDidReloadData:self];
    }
    if(completion) {
        completion();
    }
}

- (id<TECSectionModelProtocol>)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.sections[idx];
}

- (void)setObject:(id<TECSectionModelProtocol>)object atIndexedSubscript:(NSUInteger)idx {
    NSParameterAssert(object);
    self.sections[idx] = object;
}

- (void)performBatchUpdatesWithBlock:(TECContentProviderBatchUpdatesBlock)block {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:YES];
    if (block) {
        block(self);
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:YES];
}

- (void)insertSection:(id <TECSectionModelProtocol>)section atIndex:(NSUInteger)index {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:NO];
    [self.sections insertObject:section atIndex:index];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeSection:
                                                               atIndex:
                                                               forChangeType:)]) {
        [self.presentationAdapter contentProviderDidChangeSection:section
                                                          atIndex:index
                                                    forChangeType:TECContentProviderSectionChangeTypeInsert];
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:NO];
}

- (void)deleteSectionAtIndex:(NSUInteger)index {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:NO];
    id<TECSectionModelProtocol> section = self[index];
    [self.sections removeObjectAtIndex:index];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeSection:
                                                               atIndex:
                                                               forChangeType:)]) {
        [self.presentationAdapter contentProviderDidChangeSection:section
                                                          atIndex:index
                                                    forChangeType:TECContentProviderSectionChangeTypeDelete];
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:NO];
}

- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:NO];
    [self[indexPath.section] insertItem:item atIndex:indexPath.row];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeItem:
                                                               atIndexPath:
                                                               forChangeType:
                                                               newIndexPath:)]) {
        [self.presentationAdapter contentProviderDidChangeItem:item
                                                   atIndexPath:indexPath
                                                 forChangeType:TECContentProviderItemChangeTypeInsert
                                                  newIndexPath:nil];
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:NO];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:NO];
    id item = self[indexPath.section][indexPath.row];
    [self[indexPath.section] removeItemAtIndex:indexPath.row];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeItem:
                                                               atIndexPath:
                                                               forChangeType:
                                                               newIndexPath:)]) {
        [self.presentationAdapter contentProviderDidChangeItem:item
                                                   atIndexPath:indexPath
                                                 forChangeType:TECContentProviderItemChangeTypeDelete
                                                  newIndexPath:nil];
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:NO];
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateItemAtIndexPath:indexPath withItem:nil];
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:NO];
    if (item != nil) {
        self[indexPath.section][indexPath.row] = item;
    }
    else {
        item = self[indexPath.section][indexPath.row];
    }
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeItem:
                                                               atIndexPath:
                                                               forChangeType:
                                                               newIndexPath:)]) {
        [self.presentationAdapter contentProviderDidChangeItem:item
                                                   atIndexPath:indexPath
                                                 forChangeType:TECContentProviderItemChangeTypeUpdate
                                                  newIndexPath:nil];
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:NO];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self notifyWillChangeContentIfNeededIsBatchUpdate:NO];
    id item = self[indexPath];
    [self[indexPath.section] removeItemAtIndex:indexPath.row];
    [self[newIndexPath.section] insertItem:item atIndex:newIndexPath.row];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeItem:
                                                               atIndexPath:
                                                               forChangeType:
                                                               newIndexPath:)]) {
        [self.presentationAdapter contentProviderDidChangeItem:item
                                                   atIndexPath:indexPath
                                                 forChangeType:TECContentProviderItemChangeTypeMove
                                                  newIndexPath:newIndexPath];
    }
    [self notifyDidChangeContentIfNeededIsBatchUpdate:NO];
}

#pragma mark - NSFastEnumeration implementation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id  _Nonnull *)buffer
                                    count:(NSUInteger)len {
    return [self.sections countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count {
    return self.sections.count;
}

- (NSEnumerator *)sectionEnumerator {
    return [self.sections objectEnumerator];
}

- (NSEnumerator *)reverseSectionEnumerator {
    return [self.sections reverseObjectEnumerator];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id <TECSectionModelProtocol>, NSUInteger, BOOL *))block {
    [self enumerateObjectsUsingBlock:block options:0];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id <TECSectionModelProtocol>, NSUInteger, BOOL *))block
                           options:(NSEnumerationOptions)options {
    __block volatile int32_t idx = 0;
    __block BOOL stop = NO;
    BOOL isEnumerationConcurrent = options & NSEnumerationConcurrent;
    BOOL isEnumerationReverse = options & NSEnumerationReverse;
    NSEnumerator *enumerator = isEnumerationReverse ? [self reverseSectionEnumerator] : [self sectionEnumerator];
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

- (id)objectForKeyedSubscript:(NSIndexPath *)key {
    return [self itemAtIndexPath:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSIndexPath *)key {
    NSParameterAssert(object);
    self[key.section][key.row] = object;
}

#pragma mark - helper

- (void)notifyWillChangeContentIfNeededIsBatchUpdate:(BOOL)isBatchUpdate {
    [self notifyChangeContentBeginIfNeeded:YES];
    if (isBatchUpdate) {
        self.isBatchUpdating = YES;
    }
}

- (void)notifyDidChangeContentIfNeededIsBatchUpdate:(BOOL)isBatchUpdate {
    if (isBatchUpdate) {
        self.isBatchUpdating = NO;
    }
    [self notifyChangeContentBeginIfNeeded:NO];
}

- (void)notifyChangeContentBeginIfNeeded:(BOOL)willOrDid {
    SEL selector = willOrDid ?
                    @selector(contentProviderWillChangeContent:) :
                    @selector(contentProviderDidChangeContent:);
    BOOL shouldUpdate = !self.isBatchUpdating & (self.isUpdating ^ willOrDid);
    if (shouldUpdate) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([self.presentationAdapter respondsToSelector:selector]) {
            [self.presentationAdapter performSelector:selector withObject:self];
        }
#pragma clang diagnostic pop
        self.isUpdating = !self.isUpdating;
    }
}

@end
