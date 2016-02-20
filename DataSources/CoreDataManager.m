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

#define TEST_PERSON_ARRAY_NAME @[@"Alexey Fayzullov", @"Anastasiya Gorban", @"Petro Korienev", @"Sergey Zenchenko"]
#define TEST_PERSON_ARRAY_PHONE @[@"+380670000000", @"+380670000001", @"+380670000002", @"+380670000003"]

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
    NSManagedObjectContext *main = self.mainManagedObjectContext;
    NSManagedObjectContext *background = self.backgroundManagedObjectContext;
    [main performBlock:^() {
        NSFetchRequest *frPerson = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Person class])];
        NSFetchRequest *frPersonOrdered = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([PersonOrdered class])];
        NSArray *persons = [main executeFetchRequest:frPerson error:NULL];
        if (!persons.count) {
            [background performBlock:^() {
                NSEntityDescription *personEntityDescription = [NSEntityDescription entityForName:NSStringFromClass([Person class]) inManagedObjectContext:background];
                [TEST_PERSON_ARRAY_NAME enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                    Person *person = [[Person alloc] initWithEntity:personEntityDescription insertIntoManagedObjectContext:background];
                    person.name = name;
                    person.phone = TEST_PERSON_ARRAY_PHONE[idx];
                }];
                [background save:NULL];
            }];
        }
        NSArray *personsOrdered = [main executeFetchRequest:frPersonOrdered error:NULL];
        if (!personsOrdered.count) {
            [background performBlock:^() {
                NSEntityDescription *personOrderedEntityDescription = [NSEntityDescription entityForName:NSStringFromClass([PersonOrdered class]) inManagedObjectContext:background];
                [TEST_PERSON_ARRAY_NAME enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                    PersonOrdered *personOrdered = [[PersonOrdered alloc] initWithEntity:personOrderedEntityDescription insertIntoManagedObjectContext:background];
                    personOrdered.name = name;
                    personOrdered.phone = TEST_PERSON_ARRAY_PHONE[idx];
                    personOrdered.ordinal = @(idx);
                }];
                [background save:NULL];
            }];
        }
    }];
}

- (void)cleanup {
    NSManagedObjectModel *model = self.managedObjectModel;
    NSManagedObjectContext *background = self.backgroundManagedObjectContext;
    [background performBlockAndWait:^() {
        for (NSEntityDescription *entity in model.entities) {
            NSFetchRequest *fetchRequest = [NSFetchRequest new];
            fetchRequest.entity = entity;
            NSArray *objects = [background executeFetchRequest:fetchRequest error:NULL];
            for (NSManagedObject *object in objects) {
                [background deleteObject:object];
            }
        }
        [background save:NULL];
    }];
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
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
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

@end
