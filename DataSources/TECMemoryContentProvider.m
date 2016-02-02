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

@property (nonatomic, copy) NSArray<id<TECSectionModelProtocol>> *sections;

@end

@implementation TECMemoryContentProvider
@synthesize presentationAdapter = _presentationAdapter;

- (instancetype)initWithSections:(NSArray<id<TECSectionModelProtocol>> *)sections {
    self = [super init];
    if(self) {
        self.sections = sections;
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
    [self.presentationAdapter contentProviderDidReloadData:self];
    if(completion) {
        completion();
    }
}

- (id<TECSectionModelProtocol>)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.sections[idx];
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
    for (id object in (options & NSEnumerationReverse) ? [self reverseSectionEnumerator] : [self sectionEnumerator] ) {
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

- (id)objectForKeyedSubscript:(NSIndexPath *)key {
    return [self itemAtIndexPath:key];
}

@end
