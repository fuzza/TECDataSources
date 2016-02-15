//
//  TECMainContextObjectGetter.m
//  DataSources
//
//  Created by Petro Korienev on 2/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECMainContextObjectGetter.h"

@interface TECMainContextObjectGetter ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation TECMainContextObjectGetter

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context);
    self = [self init];
    if (self) {
        self.context = context;
    }
    return self;
}

- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath {
    NSParameterAssert(fetchRequest);
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.context
                                                 sectionNameKeyPath:sectionNameKeyPath
                                                          cacheName:nil];
}

- (void)fetchItemsForFetchRequest:(NSFetchRequest *)fetchRequest
                        withBlock:(TECFetchedResultsControllerContentProviderGetterFetchResultBlock)block {
    NSParameterAssert(block);
    NSParameterAssert(fetchRequest);
    NSManagedObjectContext *context = self.context;
    TECFetchedResultsControllerContentProviderGetterFetchResultBlock innerBlock = [block copy];
    [context performBlock:^() {
        NSError *error = nil;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        if (innerBlock) {
            innerBlock(items, error);
        }
    }];
}

@end
