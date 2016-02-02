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
});

SPEC_END
