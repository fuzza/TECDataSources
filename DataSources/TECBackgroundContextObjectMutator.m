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
             ofEntity:(NSEntityDescription *)entity
            withBlock:(TECFetchedResultsControllerContentProviderMutatorArrayChangeBlock)block {
    NSParameterAssert(objects);
    NSParameterAssert(entity);
    NSParameterAssert(block);
    NSArray *objectIDs = [objects valueForKeyPath:@"objectID"];
    NSMutableArray *objectsToMutate = [objectIDs mutableCopy];
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", objectIDs];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *managedObject in fetchedObjects) {
            [objectsToMutate replaceObjectAtIndex:[objectIDs indexOfObject:managedObject.objectID]
                                       withObject:managedObject];
        }
        block([NSArray arrayWithArray:objectsToMutate], error);
        [context save:&error];
    }];
}

- (void)mutateObject:(NSManagedObject *)object
           withBlock:(TECFetchedResultsControllerContentProviderMutatorObjectChangeBlock)block {
    NSParameterAssert(object);
    NSParameterAssert(block);
    NSManagedObjectID *objectID = object.objectID;
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSManagedObject *objectRefetched = [context existingObjectWithID:objectID error:&error];
        block(objectRefetched, error);
        [context save:&error];
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
             ofEntity:(NSEntityDescription *)entity {
    NSParameterAssert(objects);
    NSParameterAssert(entity);
    NSArray *objectIDs = [objects valueForKeyPath:@"objectID"];
    NSManagedObjectContext *context = self.context;
    [context performBlock:^() {
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = entity;
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", objectIDs];
        NSArray *objectsToRemove = [context executeFetchRequest:fetchRequest error:&error];
        for(NSManagedObject *object in objectsToRemove) {
            [context deleteObject:object];
        }
    }];
}

@end
