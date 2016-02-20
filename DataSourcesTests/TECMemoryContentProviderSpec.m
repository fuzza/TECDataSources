//
//  TECMemoryContentProviderSpec.m
//  DataSources
//
//  Created by Petro Korienev on 2/2/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECContentProviderDelegate.h"
#import "TECMemoryContentProvider.h"
#import "TECMemorySectionModel.h"

@interface TECMemoryContentProvider (Test)

@property (nonatomic, strong, readwrite) NSArray *sections;

@end

void verifyReceiveSelectorsArrayByMockAndTestBlock(NSArray *selectorsArray, id mock, void(^block)()) {
    NSMutableArray *calledMethods = [NSMutableArray new];
    [[NSSet setWithArray:selectorsArray] enumerateObjectsUsingBlock:^(NSString *selectorString, BOOL *stop) {
        [mock stub:NSSelectorFromString(selectorString)
         withBlock:^id(NSArray *params) {
             [calledMethods addObject:selectorString];
             return nil;
         }];
    }];
    if(block) {
        block();
    }
    [[calledMethods should] equal:selectorsArray];
}

SPEC_BEGIN(TECMemoryContentProviderSpec)

let(testString1, ^id{return @"one";});
let(testString2, ^id{return @"two";});
let(testArray1, ^id{return @[testString1];});
let(testArray2, ^id{return @[testString1, testString2];});

TECMemorySectionModel * __block section1 = nil;
TECMemorySectionModel * __block section2 = nil;
TECMemoryContentProvider * __block provider = nil;

describe(@"TECMemoryContentProvider initialization", ^() {
    
    it(@"should correctly initialize items array calling -initWithItems:", ^() {
    });
});

describe(@"Cocoa collection support", ^() {
    
    NSMutableArray * __block array1 = nil;
    
    beforeEach(^() {
        section1 = [[TECMemorySectionModel alloc] initWithItems:testArray1];
        section2 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        array1 = [NSMutableArray array];
        provider = [[TECMemoryContentProvider alloc] initWithSections:@[section1, section2]];
    });
    
    it(@"should correctly count items", ^() {
        [[theValue(provider.count) should] equal:theValue(2)];
    });
    
    it(@"should return section within bracketed notation for index", ^() {
        [[section2 should] beIdenticalTo:provider[1]];
    });
    
    it(@"should return object within bracketed notation for key", ^() {
        [[testString2 should] beIdenticalTo:provider[[NSIndexPath indexPathForRow:1 inSection:1]]];
    });
    
    it(@"should enumerate objects with for-in construct", ^() {
        for (id <TECSectionModelProtocol> section in provider) {
            [array1 addObject:section];
        }
        [[array1 should] equal:@[section1, section2]];
    });
    
    it(@"should return section enumerator", ^() {
        [[provider.sectionEnumerator shouldNot] beNil];
    });
    
    it(@"should return reverse section enumerator", ^() {
        [[provider.reverseSectionEnumerator shouldNot] beNil];
    });
    
    it(@"should enumerate sections via direct enumerator", ^() {
        for (id <TECSectionModelProtocol> section in provider.sectionEnumerator) {
            [array1 addObject:section];
        }
        [[array1 should] equal:@[section1, section2]];
    });
    
    it(@"should enumerate sections via reverse enumerator", ^() {
        for (id <TECSectionModelProtocol> section in provider.reverseSectionEnumerator) {
            [array1 addObject:section];
        }
        [[array1 should] equal:@[section2, section1]];
    });
    
    it(@"should enumerate sections via block directly", ^() {
        [provider enumerateObjectsUsingBlock:^(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
        }];
        [[array1 should] equal:@[section1, section2]];
    });
    
    it(@"should enumerate sections via block in reverse order", ^() {
        [provider enumerateObjectsUsingBlock:^(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
        } options:NSEnumerationReverse];
        [[array1 should] equal:@[section2, section1]];
    });
    
    it(@"should enumerate sections via block concurrently", ^() {
        [provider enumerateObjectsUsingBlock:^(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop) {
            @synchronized(array1) {
                [array1 addObject:obj];
            }
        } options:NSEnumerationConcurrent];
        [[array1 shouldEventually] containObjectsInArray:@[section1, section2]];
    });
        
    it(@"should respect stop parameter when enumerating directly", ^() {
        [provider enumerateObjectsUsingBlock:^(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
            *stop = YES;
        }];
        [[array1 should] equal:@[section1]];
    });
    
    it(@"should respect stop parameter when enumerating in reverse order", ^() {
        [provider enumerateObjectsUsingBlock:^(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
            *stop = YES;
        } options:NSEnumerationReverse];
        [[array1 should] equal:@[section2]];
    });
});

describe(@"Adaptor callbacks", ^{
    KWMock<TECContentProviderPresentationAdapterProtocol> * __block adaptorNullMock = nil;
    KWMock<TECContentProviderPresentationAdapterProtocol> * __block adaptorMock = nil;
    
    beforeEach(^{
        adaptorNullMock = [KWMock nullMockForProtocol:@protocol(TECContentProviderPresentationAdapterProtocol)];
        adaptorMock = [KWMock mockForProtocol:@protocol(TECContentProviderPresentationAdapterProtocol)];
        section1 = [[TECMemorySectionModel alloc] initWithItems:testArray1];
        section2 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        provider = [[TECMemoryContentProvider alloc] initWithSections:@[section1, section2]];
        provider.presentationAdapter = adaptorNullMock;
    });

    it(@"should call contentProviderDidReloadData after reloading data", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidReloadData:) withArguments:provider];
        [provider reloadDataSourceWithCompletion:nil];
    });
    
    it(@"should call callbacks in appropriate order when inserting a section", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeSection:atIndex:forChangeType:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                          ^() {
                                                [provider insertSection:section2 atIndex:2];
                                          });
    });
    
    it(@"should call contentProviderWillChangeContent when inserting a section", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:provider];
        [provider insertSection:section2 atIndex:2];
    });
    
    it(@"should call contentProviderDidChangeSection when inserting a section", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeSection:atIndex:forChangeType:) withArguments:section2, theValue(2), theValue(TECContentProviderSectionChangeTypeInsert)];
        [provider insertSection:section2 atIndex:2];
    });
    
    it(@"should call contentProviderDidChangeContent when inserting a section", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:provider];
        [provider insertSection:section2 atIndex:2];
    });
    
    it(@"should call callbacks in appropriate order when deleting a section", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeSection:atIndex:forChangeType:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                          ^() {
                                              [provider deleteSectionAtIndex:1];
                                          });
    });
    
    it(@"should call contentProviderWillChangeContent when deleting a section", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:provider];
        [provider deleteSectionAtIndex:1];
    });
    
    it(@"should call contentProviderDidChangeSection when deleting a section", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeSection:atIndex:forChangeType:) withArguments:section2, theValue(1), theValue(TECContentProviderSectionChangeTypeDelete)];
        [provider deleteSectionAtIndex:1];
    });
    
    it(@"should call contentProviderDidChangeContent when deleting a section", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:provider];
        [provider deleteSectionAtIndex:1];
    });
    
    it(@"should call callbacks in appropriate order when inserting an item", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                          ^() {
                                              [provider insertItem:testString1 atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                                          });
    });
    
    it(@"should call contentProviderWillChangeContent when inserting an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:provider];
        [provider insertItem:testString1 atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call contentProviderDidChangeItem when inserting an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:) withArguments:testString1, nil, theValue(TECContentProviderItemChangeTypeInsert), [NSIndexPath indexPathForItem:0 inSection:0]];
        [provider insertItem:testString1 atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call contentProviderDidChangeContent when inserting an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:provider];
        [provider insertItem:testString1 atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call callbacks in appropriate order when deleting an item", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                          ^() {
                                              [provider deleteItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                                          });
    });
    
    it(@"should call contentProviderWillChangeContent when deleting an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:provider];
        [provider deleteItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call contentProviderDidChangeItem when deleting an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:) withArguments:testString1, [NSIndexPath indexPathForItem:0 inSection:0], theValue(TECContentProviderItemChangeTypeDelete), nil];
        [provider deleteItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call contentProviderDidChangeContent when deleting an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:provider];
        [provider deleteItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call callbacks in appropriate order when updating an item", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                          ^() {
                                              [provider updateItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                                          });
    });
    
    it(@"should call contentProviderWillChangeContent when updating an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:provider];
        [provider updateItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call contentProviderDidChangeItem when updating an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:) withArguments:testString1, [NSIndexPath indexPathForItem:0 inSection:0], theValue(TECContentProviderItemChangeTypeUpdate), nil];
        [provider updateItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call contentProviderDidChangeContent when updating an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:provider];
        [provider updateItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    it(@"should call callbacks in appropriate order when moving an item", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                          ^() {
                                              [provider moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
                                          });
    });
    
    it(@"should call contentProviderWillChangeContent when moving an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:provider];
        [provider moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    });
    
    it(@"should call contentProviderDidChangeItem when moving an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:) withArguments:testString1, [NSIndexPath indexPathForItem:0 inSection:0], theValue(TECContentProviderItemChangeTypeMove), [NSIndexPath indexPathForItem:0 inSection:1]];
        [provider moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    });
    
    it(@"should call contentProviderDidChangeContent when moving an item", ^() {
        [[adaptorNullMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:provider];
        [provider moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    });
    
    it(@"should call callbacks in appropriate order when performing batch updates", ^() {
        provider.presentationAdapter = adaptorMock;
        verifyReceiveSelectorsArrayByMockAndTestBlock(@[NSStringFromSelector(@selector(contentProviderWillChangeContent:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:)),
                                            NSStringFromSelector(@selector(contentProviderDidChangeContent:))], adaptorMock,
                                            ^() {
                                                [provider performBatchUpdatesWithBlock:^(id<TECContentProviderProtocol> aProvider){
                                                    [aProvider insertItem:testString2 atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                                                    [aProvider deleteItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                                                }];
                                            });
    });
});

SPEC_END
