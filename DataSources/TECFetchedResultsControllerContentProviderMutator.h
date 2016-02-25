//
//  TECFetchedResultsControllerContentProviderMutator.h
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^TECFetchedResultsControllerContentProviderMutatorArrayChangeBlock)(NSArray<NSManagedObject *> *objects, NSError *error);
typedef void(^TECFetchedResultsControllerContentProviderMutatorObjectChangeBlock)(NSManagedObject *object, NSError *error);

@protocol TECFetchedResultsControllerContentProviderMutator <NSObject>

- (void)mutateObjects:(NSArray <NSManagedObject *> *)objects
             ofEntity:(NSEntityDescription *)entity
            withBlock:(TECFetchedResultsControllerContentProviderMutatorArrayChangeBlock)block;
- (void)mutateObject:(NSManagedObject *)object
           withBlock:(TECFetchedResultsControllerContentProviderMutatorObjectChangeBlock)block;
- (void)insertObject:(NSManagedObject *)object;
- (void)deleteObject:(NSManagedObject *)object;
- (void)insertObjects:(NSArray <NSManagedObject *> *)objects;
- (void)deleteObjects:(NSArray <NSManagedObject *> *)objects
             ofEntity:(NSEntityDescription *)entity;

@end
