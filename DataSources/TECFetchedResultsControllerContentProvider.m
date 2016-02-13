//
//  TECFetchedResultsControllerContentProvider.m
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECFetchedResultsControllerContentProvider.h"

@interface TECFetchedResultsControllerContentProvider ()

@property (nonatomic, weak) id <TECFetchedResultsControllerContentProviderGetter> itemsGetter;
@property (nonatomic, weak) id <TECFetchedResultsControllerContentProviderMutator> itemsMutator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

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
    }
    return self;
}

#pragma mark - NSFastEnumeration implementation

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    return [self.fetchedResultsController.sections countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count {
    return self.fetchedResultsController.sections.count;
}

- (NSEnumerator *)sectionEnumerator {
    return [self.fetchedResultsController.sections objectEnumerator];
}

- (NSEnumerator *)reverseSectionEnumerator {
    return [self.fetchedResultsController.sections reverseObjectEnumerator];
}

- (NSInteger)numberOfSections {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (void)deleteSectionAtIndex:(NSUInteger)index {
    
}

- (void)insertSection:(id<TECSectionModelProtocol>)section atIndex:(NSUInteger)index {
    
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item {
    
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    
}

- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (id)objectForKeyedSubscript:(NSIndexPath *)key {
    return [self itemAtIndexPath:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSIndexPath *)key {
    
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self sectionAtIndex:idx];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx {
    
}

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)idx {
    return (id<TECSectionModelProtocol>)self.fetchedResultsController.sections[idx];
}

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion {
    
}

- (void)performBatchUpdatesWithBlock:(TECContentProviderBatchUpdatesBlock)block {
    
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    [self enumerateObjectsUsingBlock:block options:0];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block options:(NSEnumerationOptions)options {
    
}

@end
