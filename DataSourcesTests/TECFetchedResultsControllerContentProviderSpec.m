//
//  TECFetchedResultsControllerContentProviderSpec.m
//  DataSources
//
//  Created by Petro Korienev on 2/17/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECContentProviderDelegate.h"
#import "TECFetchedResultsControllerContentProvider.h"
#import "TECCoreDataSectionModel.h"
#import "TECFetchedResultsControllerContentProviderGetter.h"
#import "TECFetchedResultsControllerContentProviderMutator.h"

@interface TECFetchedResultsControllerContentProvider (Test)

@property (nonatomic, strong) id <TECFetchedResultsControllerContentProviderGetter> itemsGetter;
@property (nonatomic, strong) id <TECFetchedResultsControllerContentProviderMutator> itemsMutator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray<TECCoreDataSectionModel *> *sectionModelArray;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *changeSetArray;

- (void)snapshotSectionModelArray;
- (void)resetChangeSetArray;

@end

SPEC_BEGIN(TECFetchedResultsControllerContentProviderSpec)

let(testString1, ^id{return @"one";});
let(testString2, ^id{return @"two";});
let(testArray1, ^id{return @[testString1];});
let(testArray2, ^id{return @[testString1, testString2];});

TECFetchedResultsControllerContentProvider  * __block provider = nil;
NSPersistentStoreCoordinator * __block inMemoryPersistentStoreCoordinator = nil;
NSManagedObjectContext * __block inMemoryMainContext = nil;
NSManagedObjectContext * __block inMemoryBackgroundContext = nil;

let(managedObjectModel, ^NSManagedObjectModel *{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataSources" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
});

let(getterMock, ^KWMock<TECFetchedResultsControllerContentProviderGetter> *{
    return [KWMock nullMockForProtocol:@protocol(TECFetchedResultsControllerContentProviderGetter)];
});

let(mutatorMock, ^KWMock<TECFetchedResultsControllerContentProviderMutator> *{
    return [KWMock nullMockForProtocol:@protocol(TECFetchedResultsControllerContentProviderMutator)];
});

let(templateFetchRequest, ^NSFetchRequest *{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return fetchRequest;
});

void(^CoreDataMockBlock)() = ^() {
    inMemoryPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    inMemoryMainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    inMemoryBackgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    inMemoryMainContext.persistentStoreCoordinator = inMemoryPersistentStoreCoordinator;
    inMemoryBackgroundContext.persistentStoreCoordinator = inMemoryPersistentStoreCoordinator;
    id __block observer = nil;
    __weak NSManagedObjectContext *weakMainContext = inMemoryMainContext;
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:inMemoryBackgroundContext
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note)
    {
        [weakMainContext mergeChangesFromContextDidSaveNotification:note];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
};

describe(@"Cocoa collection support", ^() {
    provider = nil;
});

describe(@"Init", ^() {
    beforeEach(^() {
        CoreDataMockBlock();
    });

    it(@"should set properties", ^() {
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:nil];
        [[getterMock should] equal:provider.itemsGetter];
        [[mutatorMock should] equal:provider.itemsMutator];
    });
    
    it(@"should ask getter for FRC", ^() {
        [[getterMock should] receive:@selector(fetchedResultsControllerForFetchRequest:sectionNameKeyPath:)
                       withArguments:templateFetchRequest, @"name"];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
    });
    
    it(@"should set FRC from getter", ^() {
        KWMock *frcMock = [KWMock nullMockForClass:[NSFetchedResultsController class]];
        [getterMock stub:@selector(fetchedResultsControllerForFetchRequest:sectionNameKeyPath:)
               andReturn:frcMock];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        [[provider.fetchedResultsController should] equal:frcMock];
    });
    
    it(@"should set self as FRCs delegate and perform fetch", ^() {
        KWMock *frcMock = [KWMock nullMockForClass:[NSFetchedResultsController class]];
        [getterMock stub:@selector(fetchedResultsControllerForFetchRequest:sectionNameKeyPath:)
               andReturn:frcMock];
        [[frcMock should] receive:@selector(performFetch:)];
        KWCaptureSpy *setDelegateSpy = [frcMock captureArgument:@selector(setDelegate:) atIndex:0];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        [[setDelegateSpy.argument should] equal:provider];
    });
    
    it(@"should snapshot section model array", ^() {
        KWMock *frcMock = [KWMock nullMockForClass:[NSFetchedResultsController class]];
        [getterMock stub:@selector(fetchedResultsControllerForFetchRequest:sectionNameKeyPath:)
               andReturn:frcMock];
        provider = [TECFetchedResultsControllerContentProvider alloc];
        [[provider should] receive:@selector(snapshotSectionModelArray)];
        [[provider should] receive:@selector(resetChangeSetArray)];
        provider = [provider initWithItemsGetter:getterMock
                                    itemsMutator:mutatorMock
                                    fetchRequest:templateFetchRequest
                              sectionNameKeyPath:@"name"];
    });
});

describe(@"Workarounds & changeset accumulator", ^() {
    beforeEach(^() {
        CoreDataMockBlock();
    });
});

SPEC_END
