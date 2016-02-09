//
//  TECContentProviderProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECSectionModelProtocol.h"

@protocol TECContentProviderPresentationAdapterProtocol;
@protocol TECContentProviderProtocol;

typedef void(^TECContentProviderCompletionBlock)();
typedef void(^TECContentProviderBatchUpdatesBlock)(id<TECContentProviderProtocol> provider);

@protocol TECContentProviderProtocol <NSObject, NSFastEnumeration>

@property (nonatomic, weak) id <TECContentProviderPresentationAdapterProtocol> presentationAdapter;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)index;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion;

- (void)performBatchUpdatesWithBlock:(TECContentProviderBatchUpdatesBlock)block;
- (void)insertSection:(id <TECSectionModelProtocol>)section atIndex:(NSUInteger)index;
- (void)deleteSectionAtIndex:(NSUInteger)index;
- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;
- (NSEnumerator *)sectionEnumerator;
- (NSEnumerator *)reverseSectionEnumerator;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block options:(NSEnumerationOptions)options;

- (id)objectForKeyedSubscript:(NSIndexPath *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSIndexPath *)key;

@end
