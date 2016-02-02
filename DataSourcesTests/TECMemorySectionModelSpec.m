//
//  TECMemorySectionModelSpec.m
//  DataSources
//
//  Created by Petro Korienev on 2/2/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECMemorySectionModel.h"

@interface TECMemorySectionModel (Test)

@property (nonatomic, strong, readwrite) NSArray *items;
@property (nonatomic, strong, readwrite) NSString *headerTitle;
@property (nonatomic, strong, readwrite) NSString *footerTitle;

@end

SPEC_BEGIN(TECMemorySectionModelSpec)

let(testString1, ^id{return @"one";});
let(testString2, ^id{return @"two";});
let(testArray1, ^id{return @[testString1];});
let(testArray2, ^id{return @[testString1, testString2];});

describe(@"TECMemorySectionModel initialization", ^() {
    
    it(@"should correctly initialize items array calling -initWithItems:", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray1];
        [[model.items should] equal:testArray1];
    });
    
    it(@"should correctly initialize items array calling -initWithItems:headerTitle:footerTitle:", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray1 headerTitle:testString1 footerTitle:testString2];
        [[model.items should] equal:testArray1];
    });
});

describe(@"TECMemorySectionModel mutation", ^() {
    
    it(@"should correctly replace items array", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray1];
        [model replaceItems:testArray2];
        [[model.items should] equal:testArray2];
    });
});

describe(@"Cocoa collection support", ^() {
    it(@"should correctly count items", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [[theValue([model count]) should] equal:theValue(2)];
    });
    
    it(@"should return object within bracketed notation", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [[model[1] should] equal:testString2];
    });
    
    it(@"should enumerate objects with for-in construct", ^() {
        NSMutableArray *array = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        for (NSString *item in model) {
            [array addObject:item];
        }
        [[array should] equal:testArray2];
    });
    
    it(@"should return object enumerator", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [[[model objectEnumerator] shouldNot] beNil];
    });
    
    it(@"should return reverse object enumerator", ^() {
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [[[model reverseObjectEnumerator] shouldNot] beNil];
    });
    
    it(@"should enumerate objects via direct enumerator", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        for(id object in model) {
            [array1 addObject:object];
        }
        for(id object in model.objectEnumerator) {
            [array2 addObject:object];
        }
        [[array1 should] equal:array2];
    });
    
    it(@"should enumerate objects via reverse enumerator", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        for(id object in model) {
            [array1 insertObject:object atIndex:0];
        }
        for(id object in model.reverseObjectEnumerator) {
            [array2 addObject:object];
        }
        [[array1 should] equal:array2];
    });
    
    it(@"should enumerate objects via block directly", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
        }];
        [[array1 should] equal:testArray2];
    });
    
    it(@"should enumerate objects via block in reverse order", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        for(id object in model) {
            [array1 insertObject:object atIndex:0];
        }
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array2 addObject:obj];
        } options:NSEnumerationReverse];
        [[array1 should] equal:array2];
    });
    
    it(@"should enumerate objects via block concurrently", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        for(id object in model) {
            [array1 addObject:object];
        }
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array2 addObject:obj];
        } options:NSEnumerationConcurrent];
        [[array1 shouldEventually] equal:array2];
    });
    
    it(@"should enumerate objects via block concurrently in reverse order", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        for(id object in model) {
            [array1 insertObject:object atIndex:0];
        }
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array2 addObject:obj];
        } options:NSEnumerationConcurrent | NSEnumerationReverse];
        [[array1 shouldEventually] equal:array2];
    });
    
    it(@"should respect stop parameter when enumerating directly", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
            *stop = YES;
        }];
        [[array1 should] equal:testArray1];
    });
    
    it(@"should respect stop parameter when enumerating in reverse order", ^() {
        NSMutableArray *array1 = [NSMutableArray array];
        TECMemorySectionModel *model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
            *stop = YES;
        } options:NSEnumerationReverse];
        [[array1 should] equal:@[testString2]];
    });
});

SPEC_END
