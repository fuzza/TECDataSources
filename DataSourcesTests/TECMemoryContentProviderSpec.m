//
//  TECMemoryContentProviderSpec.m
//  DataSources
//
//  Created by Petro Korienev on 2/2/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECMemoryContentProvider.h"
#import "TECMemorySectionModel.h"

@interface TECMemoryContentProvider (Test)

@property (nonatomic, strong, readwrite) NSArray *sections;

@end

SPEC_BEGIN(TECMemoryContentProviderSpec)

describe(@"TECMemoryContentProvider initialization", ^() {
    
    it(@"should correctly initialize items array calling -initWithItems:", ^() {
    });
});

describe(@"Cocoa collection support", ^() {
    
    let(testString1, ^id{return @"one";});
    let(testString2, ^id{return @"two";});
    let(testArray1, ^id{return @[testString1];});
    let(testArray2, ^id{return @[testString1, testString2];});
    
    TECMemorySectionModel * __block section1 = nil;
    TECMemorySectionModel * __block section2 = nil;
    NSMutableArray * __block array1 = nil;
    TECMemoryContentProvider * __block provider = nil;
    
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
            [array1 addObject:obj];
        } options:NSEnumerationConcurrent];
        [[array1 shouldEventually] equal:@[section1, section2]];
    });
    
    it(@"should enumerate sections via block concurrently in reverse order", ^() {
        [provider enumerateObjectsUsingBlock:^(id <TECSectionModelProtocol> obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
        } options:NSEnumerationConcurrent | NSEnumerationReverse];
        [[array1 shouldEventually] equal:@[section2, section1]];
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

SPEC_END
