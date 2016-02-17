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

- (void)mutateObject:(NSManagedObject *)object
           withBlock:(TECFetchedResultsControllerContentProviderMutatorObjectChangeBlock)block {
    NSParameterAssert(object);
    NSParameterAssert(block);
    TECFetchedResultsControllerContentProviderMutatorObjectChangeBlock innerBlock = [block copy];
    NSManagedObjectID *objectID = object.objectID;
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSManagedObject *objectRefetched = [context existingObjectWithID:objectID error:&error];
        if (innerBlock) {
            innerBlock(objectRefetched, error);
            [context save:&error];
        }
    }];
}

- (void)insertObject:(NSManagedObject *)object {
    NSParameterAssert(object);
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        [context insertObject:object];
        [context save:&error];
    }];
}

- (void)deleteObject:(NSManagedObject *)object {
    NSParameterAssert(object);
    NSManagedObjectID *objectID = object.objectID;
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSManagedObject *objectRefetched = [context existingObjectWithID:objectID error:&error];
        [context deleteObject:objectRefetched];
        [context save:&error];
    }];
}

- (void)insertObjects:(NSArray<NSManagedObject *> *)objects {
    NSParameterAssert(objects);
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        for(NSManagedObject *object in objects) {
            [context insertObject:object];
        }
        NSError *error = nil;
        [context save:&error];
    }];
}

- (void)deleteObjects:(NSArray <NSManagedObject *> *)objects
withEntityDescription:(NSEntityDescription *)entityDescription {
    NSParameterAssert(objects);
    NSArray *objectIDs = [objects valueForKeyPath:@"objectID"];
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entityDescription;
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"objectID IN %@", objectIDs];
        NSArray *objectsToRemove = [context executeFetchRequest:fetchRequest error:&error];
        for(NSManagedObject *object in objectsToRemove) {
            [context deleteObject:object];
        }
    }];
}

@end
