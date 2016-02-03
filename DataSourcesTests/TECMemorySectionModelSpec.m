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
    
    NSMutableArray * __block array1 = nil;
    NSMutableArray * __block array2 = nil;
    TECMemorySectionModel * __block model = nil;
    
    beforeEach(^() {
        array1 = [NSMutableArray array];
        array2 = [NSMutableArray array];
        model = [[TECMemorySectionModel alloc] initWithItems:testArray2];
    });
    
    it(@"should correctly count items", ^() {
        [[theValue([model count]) should] equal:theValue(2)];
    });
    
    it(@"should return object within bracketed notation", ^() {
        [[model[1] should] equal:testString2];
    });
    
    it(@"should enumerate objects with for-in construct", ^() {
        for (NSString *item in model) {
            [array1 addObject:item];
        }
        [[array1 should] equal:testArray2];
    });
    
    it(@"should return object enumerator", ^() {
        [[[model objectEnumerator] shouldNot] beNil];
    });
    
    it(@"should return reverse object enumerator", ^() {
        [[[model reverseObjectEnumerator] shouldNot] beNil];
    });
    
    it(@"should enumerate objects via direct enumerator", ^() {
        for(id object in model) {
            [array1 addObject:object];
        }
        for(id object in model.objectEnumerator) {
            [array2 addObject:object];
        }
        [[array1 should] equal:array2];
    });
    
    it(@"should enumerate objects via reverse enumerator", ^() {
        for(id object in model) {
            [array1 insertObject:object atIndex:0];
        }
        for(id object in model.reverseObjectEnumerator) {
            [array2 addObject:object];
        }
        [[array1 should] equal:array2];
    });
    
    it(@"should enumerate objects via block directly", ^() {
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
        }];
        [[array1 should] equal:testArray2];
    });
    
    it(@"should enumerate objects via block in reverse order", ^() {
        for(id object in model) {
            [array1 insertObject:object atIndex:0];
        }
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array2 addObject:obj];
        } options:NSEnumerationReverse];
        [[array1 should] equal:array2];
    });
    
    it(@"should enumerate objects via block concurrently", ^() {
        for(id object in model) {
            [array1 addObject:object];
        }
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array2 addObject:obj];
        } options:NSEnumerationConcurrent];
        [[array1 shouldEventually] equal:array2];
    });
    
    it(@"should enumerate objects via block concurrently in reverse order", ^() {
        for(id object in model) {
            [array1 insertObject:object atIndex:0];
        }
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array2 addObject:obj];
        } options:NSEnumerationConcurrent | NSEnumerationReverse];
        [[array1 shouldEventually] equal:array2];
    });
    
    it(@"should respect stop parameter when enumerating directly", ^() {
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
            *stop = YES;
        }];
        [[array1 should] equal:testArray1];
    });
    
    it(@"should respect stop parameter when enumerating in reverse order", ^() {
        [model enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
            *stop = YES;
        } options:NSEnumerationReverse];
        [[array1 should] equal:@[testString2]];
    });
});

describe(@"NSCopying implementation", ^{

    it(@"should return equal hashes for equal models", ^() {
        TECMemorySectionModel *model1 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        TECMemorySectionModel *model2 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [[theValue([model1 hash]) should] equal:theValue([model2 hash])];
    });
    
    it(@"should consider equal models with equal items array", ^() {
        TECMemorySectionModel *model1 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        TECMemorySectionModel *model2 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        [[model1 should] equal:model2];
    });
    
    it(@"should consider different models with different items array", ^() {
        TECMemorySectionModel *model1 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        TECMemorySectionModel *model2 = [[TECMemorySectionModel alloc] initWithItems:testArray1];
        [[model1 shouldNot] equal:model2];
    });
    
    it(@"should return different instance on copy", ^() {
        TECMemorySectionModel *model1 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        TECMemorySectionModel *model2 = [model1 copy];
        [[model1 shouldNot] beIdenticalTo:model2];
    });
    
    it(@"should return equal instances on copy", ^() {
        TECMemorySectionModel *model1 = [[TECMemorySectionModel alloc] initWithItems:testArray2];
        TECMemorySectionModel *model2 = [model1 copy];
        [[model1 should] equal:model2];
    });
});

SPEC_END
