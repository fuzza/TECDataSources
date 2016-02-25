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

typedef NS_ENUM(NSUInteger, TECChangesetKind) {
    TECChangesetKindSection = 1,
    TECChangesetKindRow,
};

extern NSString * const kTECChangesetKindKey;
extern NSString * const kTECChangesetSectionKey;
extern NSString * const kTECChangesetIndexKey;
extern NSString * const kTECChangesetObjectKey;
extern NSString * const kTECChangesetIndexPathKey;
extern NSString * const kTECChangesetChangeTypeKey;
extern NSString * const kTECChangesetNewIndexPathKey;

@interface TECFetchedResultsControllerContentProvider (Test)

@property (nonatomic, strong) id <TECFetchedResultsControllerContentProviderGetter> itemsGetter;
@property (nonatomic, strong) id <TECFetchedResultsControllerContentProviderMutator> itemsMutator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray<TECCoreDataSectionModel *> *sectionModelArray;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *changeSetArray;

- (void)snapshotSectionModelArray;
- (void)resetChangeSetArray;
- (void)flushChangeSetArrayToAdapter;

- (void)workChangeSetArrayAround;
- (void)workUpdateThenMoveAround;
- (void)workConsecutiveSectionInsertDeleteAround;
- (void)workSectionBeforeRowChangeSetsAround;
- (void)workManualMovesAround;
- (void)workOddMovesAround;


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
    
    it(@"should snapshot FRC sections into correct adapter", ^() {
        KWMock *frcMock = [KWMock nullMockForClass:[NSFetchedResultsController class]];
        [getterMock stub:@selector(fetchedResultsControllerForFetchRequest:sectionNameKeyPath:)
               andReturn:frcMock];
        KWMock<NSFetchedResultsSectionInfo> *section1 = [KWMock nullMockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        KWMock<NSFetchedResultsSectionInfo> *section2 = [KWMock nullMockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        KWMock<NSFetchedResultsSectionInfo> *section3 = [KWMock nullMockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        NSArray *sectionMocksArray = @[section1, section2, section3];
        [frcMock stub:@selector(sections) andReturn:sectionMocksArray];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        [provider snapshotSectionModelArray];
        [[[provider.sectionModelArray valueForKey:@"info"] should] equal:sectionMocksArray];
    });
    
    it(@"should recreate changeset array on resetChangeSetArray", ^() {
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        [[provider should] receive:@selector(setChangeSetArray:) withArguments:@[]];
        [provider resetChangeSetArray];
    });
    
    it(@"should correctly flush changeset array to presentation adapter", ^() {
        NSArray *changesetArray =
        @[@{kTECChangesetKindKey:@(TECChangesetKindRow)},
          @{kTECChangesetKindKey:@(TECChangesetKindRow)},
          @{kTECChangesetKindKey:@(TECChangesetKindRow)},
          @{kTECChangesetKindKey:@(TECChangesetKindSection)},
          @{kTECChangesetKindKey:@(TECChangesetKindSection)}];
        KWMock<TECContentProviderPresentationAdapterProtocol> *adapter =
        [KWMock mockForProtocol:@protocol(TECContentProviderPresentationAdapterProtocol)];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        provider.presentationAdapter = adapter;
        [provider stub:@selector(changeSetArray) andReturn:changesetArray];
        [[adapter should] receive:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:) withCount:3];
        [[adapter should] receive:@selector(contentProviderDidChangeSection:atIndex:forChangeType:) withCount:2];
        [provider flushChangeSetArrayToAdapter];
    });
    
    it(@"should call workarounds consecutively", ^() {
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        [[provider should] receive:@selector(workUpdateThenMoveAround)];
        [[provider should] receive:@selector(workConsecutiveSectionInsertDeleteAround)];
        [[provider should] receive:@selector(workSectionBeforeRowChangeSetsAround)];
        [[provider should] receive:@selector(workManualMovesAround)];
        [[provider should] receive:@selector(workOddMovesAround)];
        [provider workChangeSetArrayAround];
    });

    it(@"should apply workUpdateThenMoveAround correctly", ^() {
        NSDictionary *changeset1 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeUpdate),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0]};
        NSDictionary *changeset2 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeUpdate),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:2 inSection:0]};
        NSDictionary *changeset3 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0],
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:1 inSection:0]};
        NSMutableArray *array = [@[changeset1, changeset2, changeset3] mutableCopy];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        provider.changeSetArray = array;
        [provider workUpdateThenMoveAround];
        [[provider.changeSetArray should] equal:@[changeset2, changeset3]];
    });
    
    it(@"should apply workConsecutiveSectionInsertDeleteAround correctly", ^() {
        KWMock<NSFetchedResultsSectionInfo> *section1 = [KWMock nullMockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        NSDictionary *changeset1 = @{kTECChangesetKindKey:@(TECChangesetKindSection),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeDelete),
                                     kTECChangesetIndexKey:@(0)};
        NSDictionary *changeset2 = @{kTECChangesetKindKey:@(TECChangesetKindSection),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeInsert),
                                     kTECChangesetIndexKey:@(0)};
        NSDictionary *changeset3 = @{kTECChangesetKindKey:@(TECChangesetKindSection),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeInsert),
                                     kTECChangesetIndexKey:@(1)};
        NSDictionary *changeset4 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0],
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:1]};
        NSDictionary *changeset5 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeInsert),
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:1 inSection:1]};
        NSDictionary *changeset6 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeInsert),
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:2 inSection:1]};
        
        NSDictionary *reloadChangeset = @{kTECChangesetKindKey:@(TECChangesetKindSection),
                                          kTECChangesetChangeTypeKey:@(TECContentProviderSectionChangeTypeUpdate),
                                          kTECChangesetIndexKey:@(0),
                                          kTECChangesetSectionKey:section1};
        
        NSMutableArray *array = [@[changeset1, changeset2, changeset3, changeset4, changeset5, changeset6] mutableCopy];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        provider.changeSetArray = array;
        provider.sectionModelArray = @[[[TECCoreDataSectionModel alloc] initWithFetchedResultsSectionInfo:section1]];
        [provider workConsecutiveSectionInsertDeleteAround];
        [[provider.changeSetArray should] equal:@[reloadChangeset, changeset3, changeset5, changeset6]];
    });
    
    it(@"should apply workSectionBeforeRowChangeSetsAround correctly", ^() {
        NSDictionary *changeset1 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeUpdate),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0]};
        NSDictionary *changeset2 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeUpdate),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:2 inSection:0]};
        NSDictionary *changeset3 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0],
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:1 inSection:0]};
        NSDictionary *changeset4 = @{kTECChangesetKindKey:@(TECChangesetKindSection),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeInsert),
                                     kTECChangesetIndexKey:@(0)};
        NSMutableArray *array = [@[changeset1, changeset2, changeset3, changeset4] mutableCopy];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        provider.changeSetArray = array;
        [provider workSectionBeforeRowChangeSetsAround];
        [[provider.changeSetArray should] equal:@[changeset4, changeset1, changeset2, changeset3]];
    });
    
    it(@"should apply workManualMovesAround correctly", ^() {
        NSDictionary *changeset1 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0],
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:1 inSection:0]};
        NSDictionary *changeset2 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:1 inSection:0],
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:2 inSection:0]};
        NSDictionary *changeset3 = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:2 inSection:0],
                                     kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0]};
        
        NSMutableArray *array = [@[changeset1, changeset2, changeset3] mutableCopy];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        provider.changeSetArray = array;
        [provider workManualMovesAround];
        [[provider.changeSetArray should] equal:@[]];
    });
    
    it(@"should apply workOddMovesAround correctly", ^() {
        NSMutableDictionary *changeset1 = [@{kTECChangesetKindKey:@(TECChangesetKindRow),
                                             kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeMove),
                                             kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0],
                                             kTECChangesetNewIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0]} mutableCopy];
        NSDictionary *updateChangeset = @{kTECChangesetKindKey:@(TECChangesetKindRow),
                                     kTECChangesetChangeTypeKey:@(NSFetchedResultsChangeUpdate),
                                     kTECChangesetIndexPathKey:[NSIndexPath indexPathForRow:0 inSection:0]};
        NSMutableArray *array = [@[changeset1] mutableCopy];
        provider = [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:getterMock
                                                                              itemsMutator:mutatorMock
                                                                              fetchRequest:templateFetchRequest
                                                                        sectionNameKeyPath:@"name"];
        provider.changeSetArray = array;
        [provider workOddMovesAround];
        [[provider.changeSetArray should] equal:@[updateChangeset]];
    });
});

SPEC_END
