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

typedef void(^TECContentProviderCompletionBlock)();

@protocol TECContentProviderProtocol <NSObject, NSFastEnumeration>

@property (nonatomic, weak) id <TECContentProviderPresentationAdapterProtocol> presentationAdapter;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)index;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;
- (NSEnumerator *)sectionEnumerator;
- (NSEnumerator *)reverseSectionEnumerator;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block options:(NSEnumerationOptions)options;

- (id)objectForKeyedSubscript:(NSIndexPath *)key;

@end
