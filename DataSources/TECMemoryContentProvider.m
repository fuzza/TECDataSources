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

@property (nonatomic, copy) NSMutableArray<id<TECSectionModelProtocol>> *sections;
@property (nonatomic, assign) BOOL isUpdating;

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
    if (!object) {
        [self.sections removeObjectAtIndex:idx];
    }
    else {
        self.sections[idx] = object;
    }
}

- (void)performBatchUpdatesWithBlock:(TECContentProviderBatchUpdatesBlock)block {
    [self notifyWillChangeContentIfNeeded];
    if (block) {
        block(self);
    }
    [self notifyDidChangeContentIfNeeded];
}

- (void)insertSection:(id <TECSectionModelProtocol>)section atIndex:(NSUInteger)index {
    [self notifyWillChangeContentIfNeeded];
    [self.sections insertObject:section atIndex:index];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeSection:
                                                               atIndex:
                                                               forChangeType:)]) {
        [self.presentationAdapter contentProviderDidChangeSection:section
                                                          atIndex:index
                                                    forChangeType:TECContentProviderSectionChangeTypeInsert];
    }
    [self notifyDidChangeContentIfNeeded];
}

- (void)deleteSectionAtIndex:(NSUInteger)index {
    [self notifyWillChangeContentIfNeeded];
    id<TECSectionModelProtocol> section = self[index];
    self[index] = nil;
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeSection:
                                                               atIndex:
                                                               forChangeType:)]) {
        [self.presentationAdapter contentProviderDidChangeSection:section
                                                          atIndex:index
                                                    forChangeType:TECContentProviderSectionChangeTypeDelete];
    }
    [self notifyDidChangeContentIfNeeded];
}

- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    [self notifyWillChangeContentIfNeeded];
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
    [self notifyDidChangeContentIfNeeded];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self notifyWillChangeContentIfNeeded];
    id item = self[indexPath.section][indexPath.row];
    self[indexPath.section][indexPath.row] = nil;
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeItem:
                                                               atIndexPath:
                                                               forChangeType:
                                                               newIndexPath:)]) {
        [self.presentationAdapter contentProviderDidChangeItem:item
                                                   atIndexPath:indexPath
                                                 forChangeType:TECContentProviderItemChangeTypeDelete
                                                  newIndexPath:nil];
    }
    [self notifyDidChangeContentIfNeeded];
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateItemAtIndexPath:indexPath withItem:nil];
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item {
    [self notifyWillChangeContentIfNeeded];
    if (item != nil) {
        self[indexPath.section][indexPath.row] = item;
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
    [self notifyDidChangeContentIfNeeded];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self notifyWillChangeContentIfNeeded];
    id item = self[indexPath];
    self[indexPath] = nil;
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
    [self notifyDidChangeContentIfNeeded];
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
    self[key.section][key.row] = object;
}

#pragma mark - helper

- (void)notifyWillChangeContentIfNeeded {
    [self notifyChangeContentBeginIfNeeded:YES];
}

- (void)notifyDidChangeContentIfNeeded {
    [self notifyChangeContentBeginIfNeeded:NO];
}

- (void)notifyChangeContentBeginIfNeeded:(BOOL)willOrDid {
    SEL selector = willOrDid ?
                    @selector(contentProviderWillChangeContent:) :
                    @selector(contentProviderDidChangeContent:);
    BOOL shouldUpdate = self.isUpdating ^ willOrDid;
    if (shouldUpdate) {
        if ([self.presentationAdapter respondsToSelector:selector]) {
            ((void(*)(id,SEL,id))[((NSObject *)self.presentationAdapter) methodForSelector:selector])(self.presentationAdapter, _cmd, self);
        }
        self.isUpdating = !self.isUpdating;
    }
}

@end
