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

@interface TECFetchedResultsControllerContentProvider (Test)

@property (nonatomic, strong, readwrite) NSArray *sections;

@end

SPEC_BEGIN(TECFetchedResultsControllerContentProviderSpec)

let(testString1, ^id{return @"one";});
let(testString2, ^id{return @"two";});
let(testArray1, ^id{return @[testString1];});
let(testArray2, ^id{return @[testString1, testString2];});

TECFetchedResultsControllerContentProvider  * __block provider = nil;

describe(@"Cocoa collection support", ^() {
    provider = nil;
});

describe(@"FRC support", ^() {
});

SPEC_END
