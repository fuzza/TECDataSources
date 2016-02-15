//
//  TECBackgroundContextObjectMutator.m
//  DataSources
//
//  Created by Petro Korienev on 2/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECBackgroundContextObjectMutator.h"

@interface TECBackgroundContextObjectMutator ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation TECBackgroundContextObjectMutator

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context);
    self = [self init];
    if (self) {
        self.context = context;
    }
    return self;
}


- (void)mutateObjects:(NSArray <NSManagedObject *> *)objects
withEntityDescription:(NSEntityDescription *)entityDescription
                block:(TECFetchedResultsControllerContentProviderMutatorArrayChangeBlock)block {
    NSParameterAssert(objects);
    NSParameterAssert(block);
    TECFetchedResultsControllerContentProviderMutatorArrayChangeBlock innerBlock = [block copy];
    NSArray *objectIDs = [objects valueForKeyPath:@"objectID"];
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entityDescription;
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"objectID IN %@", objectIDs];
        NSArray *objectsToMutate = [context executeFetchRequest:fetchRequest error:&error];
        if (innerBlock) {
            innerBlock(objectsToMutate, error);
            [context save:&error];
        }
    }];
}

@end
