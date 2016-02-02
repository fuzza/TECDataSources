//
//  TECMemoryContentProvider.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECContentProviderProtocol.h"

@interface TECMemoryContentProvider : NSObject <TECContentProviderProtocol>

- (instancetype)initWithSections:(NSArray <id <TECSectionModelProtocol>> *)sections;
- (id <TECSectionModelProtocol>)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSEnumerator<id <TECSectionModelProtocol>> *)sectionEnumerator;
- (NSEnumerator<id <TECSectionModelProtocol>> *)reverseSectionEnumerator;
- (void)enumerateObjectsUsingBlock:(void (^)(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsUsingBlock:(void (^)(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop))block options:(NSEnumerationOptions)options;
- (id)objectForKeyedSubscript:(NSIndexPath *)key;

@end
