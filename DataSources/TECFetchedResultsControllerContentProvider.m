//
//  TECFetchedResultsControllerContentProvider.m
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECFetchedResultsControllerContentProvider.h"
#import "TECCoreDataSectionModel.h"
#import "TECContentProviderDelegate.h"
#import <libkern/OSAtomic.h>

@interface TECFetchedResultsControllerContentProvider () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id <TECFetchedResultsControllerContentProviderGetter> itemsGetter;
@property (nonatomic, weak) id <TECFetchedResultsControllerContentProviderMutator> itemsMutator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *sectionModelArray;

@end

@implementation TECFetchedResultsControllerContentProvider

- (instancetype)initWithItemsGetter:(id<TECFetchedResultsControllerContentProviderGetter>)getter
                       itemsMutator:(id<TECFetchedResultsControllerContentProviderMutator>)mutator
                       fetchRequest:(NSFetchRequest *)fetchRequest
                 sectionNameKeyPath:(NSString *)sectionNameKeyPath {
    self = [self init];
    if (self) {
        self.itemsGetter = getter;
        self.itemsMutator = mutator;
        self.fetchedResultsController = [self.itemsGetter fetchedResultsControllerForFetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath];
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:nil];
        [self snapshotSectionModelArray];
    }
    return self;
}

- (void)snapshotSectionModelArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.fetchedResultsController.sections.count];
    for(id<NSFetchedResultsSectionInfo> sectionInfo in self.fetchedResultsController.sections) {
        [array addObject:[[TECCoreDataSectionModel alloc] initWithFetchedResultsSectionInfo:sectionInfo]];
    }
    self.sectionModelArray = [NSArray arrayWithArray:array];
}

#pragma mark - NSFastEnumeration implementation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    return [self.sectionModelArray countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count {
    return self.sectionModelArray.count;
}

- (NSEnumerator *)sectionEnumerator {
    return [self.sectionModelArray objectEnumerator];
}

- (NSEnumerator *)reverseSectionEnumerator {
    return [self.sectionModelArray reverseObjectEnumerator];
}

- (NSInteger)numberOfSections {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (void)deleteSectionAtIndex:(NSUInteger)index {
    [self.itemsMutator deleteObjects:self.fetchedResultsController.sections[index].objects
               withEntityDescription:self.fetchedResultsController.fetchRequest.entity];
}

- (void)insertSection:(id<TECSectionModelProtocol>)section atIndex:(NSUInteger)index {
    NSAssert(NO, @"%s CoreData content provider asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.fetchedResultsController.managedObjectContext refreshObject:[self.fetchedResultsController objectAtIndexPath:indexPath] mergeChanges:YES];
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item {
    NSAssert(NO, @"%s CoreData content provider asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    NSAssert(NO, @"%s CoreData content provider asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"%s CoreData content provider asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.itemsMutator deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (id)objectForKeyedSubscript:(NSIndexPath *)key {
    return [self itemAtIndexPath:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSIndexPath *)key {
    NSAssert(NO, @"%s CoreData content provider asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self sectionAtIndex:idx];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx {
    NSAssert(NO, @"%s CoreData content provider asked for ineligible mutation", __PRETTY_FUNCTION__);
}

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)idx {
    return [[TECCoreDataSectionModel alloc] initWithFetchedResultsSectionInfo:self.fetchedResultsController.sections[idx]];
}

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion {
    self.fetchedResultsController.delegate = nil;
    [self.fetchedResultsController performFetch:nil];
    self.fetchedResultsController.delegate = self;
    if (completion) {
        completion();
    }
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidReloadData:)]) {
        [self.presentationAdapter contentProviderDidReloadData:self];
    }
}

- (void)performBatchUpdatesWithBlock:(TECContentProviderBatchUpdatesBlock)block {
    if (block) {
        block(self);
    }
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    [self enumerateObjectsUsingBlock:block options:0];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block options:(NSEnumerationOptions)options {
    __block volatile int32_t idx = 0;
    __block BOOL stop = NO;
    BOOL isEnumerationConcurrent = options & NSEnumerationConcurrent;
    BOOL isEnumerationReverse = options & NSEnumerationReverse;
    NSAssert(!isEnumerationConcurrent, @"%s NSEnumerationConcurrent: doing this with CoreData is the best way to shoot own leg", __PRETTY_FUNCTION__);
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

#pragma mark - NSFetchedResutsControllerDelegate implementation

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderWillChangeContent:)]) {
        [self.presentationAdapter contentProviderWillChangeContent:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeSection:atIndex:forChangeType:)]) {
        [self.presentationAdapter contentProviderDidChangeSection:[[TECCoreDataSectionModel alloc] initWithFetchedResultsSectionInfo:sectionInfo]
                                                          atIndex:sectionIndex
                                                    forChangeType:(TECContentProviderSectionChangeType)type];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)]) {
        [self.presentationAdapter contentProviderDidChangeItem:anObject
                                                   atIndexPath:indexPath
                                                 forChangeType:(TECContentProviderItemChangeType)type
                                                  newIndexPath:newIndexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self snapshotSectionModelArray];
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeContent:)]) {
        [self.presentationAdapter contentProviderDidChangeContent:self];
    }
}

@end
