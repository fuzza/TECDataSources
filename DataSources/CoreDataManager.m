//
//  CoreDataManager.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "CoreDataManager.h"

#import "TECMainContextObjectGetter.h"
#import "TECBackgroundContextObjectMutator.h"

#import "Person.h"
#import "PersonOrdered.h"

#define TEST_PERSON_ARRAY @[@{@"name":@"Alexey Fayzullov", @"phone":@"+380670000000"},\
                            @{@"name":@"Anastasiya Gorban", @"phone":@"+380670000001"},\
                            @{@"name":@"Petro Korienev", @"phone":@"+380670000002"},\
                            @{@"name":@"Sergey Zenchenko", @"phone":@"+380670000003"}]
#define TEST_PERSON_ORDERED_ARRAY @[@{@"name":@"Alexey Fayzullov", @"phone":@"+380670000000", @"ordinal":@(0)},\
                                    @{@"name":@"Anastasiya Gorban", @"phone":@"+380670000001", @"ordinal":@(1)},\
                                    @{@"name":@"Petro Korienev", @"phone":@"+380670000002", @"ordinal":@(2)},\
                                    @{@"name":@"Sergey Zenchenko", @"phone":@"+380670000003", @"ordinal":@(3)}]

@interface CoreDataManager () {
    NSManagedObjectContext *_backgroundManagedObjectContext;
    NSManagedObjectContext *_mainManagedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataManager

+ (instancetype)sharedObject {
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^() {
        sharedObject = [self new];
    });
    return sharedObject;
}

- (void)setup {
    if (![self personCount]) {
        [self fillPersonData];
    }
    if (![self personOrderedCount]) {
        [self fillPersonOrderedData];
    }
}

- (void)cleanup {
    NSManagedObjectModel *model = self.managedObjectModel;
    for (NSEntityDescription *entity in model.entities) {
        [self cleanupAllObjectsOfEntity:entity];
    }
}

- (id<TECFetchedResultsControllerContentProviderGetter>)createObjectGetter {
    return [[TECMainContextObjectGetter alloc] initWithManagedObjectContext:self.mainManagedObjectContext];
}

- (id<TECFetchedResultsControllerContentProviderMutator>)createObjectMutator {
    return [[TECBackgroundContextObjectMutator alloc] initWithManagedObjectContext:self.backgroundManagedObjectContext];
}

- (NSFetchRequest *)createPersonFetchRequest {
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Person class])];
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return fr;
}

- (NSFetchRequest *)createPersonOrderedFetchRequest {
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([PersonOrdered class])];
    fr.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES]];
    return fr;
}

#pragma mark - lazy

- (NSURL *)containerDirectoryURL {
    return [NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataSources" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *storeURL = [[self containerDirectoryURL] URLByAppendingPathComponent:@"DataSources.sqlite"];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (_mainManagedObjectContext != nil) {
        return _mainManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (!coordinator) {
        return nil;
    }
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.backgroundManagedObjectContext];
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (!coordinator) {
        return nil;
    }
    _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundManagedObjectContext setPersistentStoreCoordinator:coordinator];
    return _backgroundManagedObjectContext;
}

- (void)contextDidSave:(NSNotification *)note {
    NSManagedObjectContext *main = self.mainManagedObjectContext;
    [main performBlock:^() {
        [main mergeChangesFromContextDidSaveNotification:note];
    }];
}

#pragma mark - helper

- (void)fillDataForEntity:(NSEntityDescription *)entity
                fromArray:(NSArray<NSDictionary *> *)array
                  context:(NSManagedObjectContext *)context {
    for (NSDictionary *dictionary in array) {
        NSManagedObject *managedObject = [[entity.class alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        [managedObject setValuesForKeysWithDictionary:dictionary];
    }
}

- (void)fillPersonData {
    NSManagedObjectContext *background = self.backgroundManagedObjectContext;
    [background performBlock:^() {
        NSEntityDescription *personEntityDescription = [NSEntityDescription entityForName:NSStringFromClass([Person class]) inManagedObjectContext:background];
        [self fillDataForEntity:personEntityDescription fromArray:TEST_PERSON_ARRAY context:background];
        [background save:NULL];
    }];
}

- (void)fillPersonOrderedData {
    NSManagedObjectContext *background = self.backgroundManagedObjectContext;
    [background performBlock:^() {
        NSEntityDescription *personOrderedEntityDescription = [NSEntityDescription entityForName:NSStringFromClass([PersonOrdered class]) inManagedObjectContext:background];
        [self fillDataForEntity:personOrderedEntityDescription fromArray:TEST_PERSON_ORDERED_ARRAY context:background];
        [background save:NULL];
    }];
}

- (NSUInteger)countOfEntities:(NSEntityDescription *)entity {
    __block NSUInteger result = 0;
    NSManagedObjectContext *main = self.mainManagedObjectContext;
    [main performBlockAndWait:^() {
        NSFetchRequest *fr = [NSFetchRequest new];
        fr.entity = entity;
        result = [main countForFetchRequest:fr error:NULL];
    }];
    return result;
}

- (NSUInteger)personCount {
    return [self countOfEntities:[NSEntityDescription entityForName:NSStringFromClass([Person class])
                                             inManagedObjectContext:self.mainManagedObjectContext]];
}

- (NSUInteger)personOrderedCount {
    return [self countOfEntities:[NSEntityDescription entityForName:NSStringFromClass([PersonOrdered class])
                                             inManagedObjectContext:self.mainManagedObjectContext]];
}

- (void)cleanupAllObjectsOfEntity:(NSEntityDescription *)entity {
    NSManagedObjectContext *background = self.backgroundManagedObjectContext;
    [background performBlockAndWait:^() {
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = entity;
        NSArray *objects = [background executeFetchRequest:fetchRequest error:NULL];
        for (NSManagedObject *object in objects) {
            [background deleteObject:object];
        }
        [background save:NULL];
    }];
}

@end
