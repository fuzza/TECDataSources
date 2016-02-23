//
//  TECBlockOperationSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/23/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECBlockOperation.h"

SPEC_BEGIN(TECBlockOperationSpec)

const void *contextKey = (void*)"kBlockQueueSpecificKey";

let(sut, ^TECBlockOperation *{
    return [TECBlockOperation new];
});

it(@"Is subclass of block operation", ^{
    [[TECBlockOperation class] isSubclassOfClass:[NSBlockOperation class]];
});

it(@"Can be initialized using factory method", ^{
    TECBlockOperation *localSut = [TECBlockOperation operation];
    [[localSut should] beKindOfClass:[TECBlockOperation class]];
});

it(@"Is initialized", ^{
    [[sut should] beKindOfClass:[TECBlockOperation class]];
});

it(@"Is not asynchronous", ^{
    [[theValue(sut.asynchronous) should] beFalse];
});

it(@"Runs all blocks synchronously on start", ^{
    dispatch_queue_t testQueue = dispatch_queue_create("block operation test_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_set_specific(testQueue, contextKey, (void *)contextKey, NULL);

    __block NSInteger count = 0;
    
    void(^executionBlock)() = ^{
        if(dispatch_get_specific(contextKey)) {
            count++;
        }
    };
    
    [sut addExecutionBlock:executionBlock];
    [sut addExecutionBlock:executionBlock];
    [sut addExecutionBlock:executionBlock];
    
    dispatch_sync(testQueue, ^{
        [sut start];
    });
    
    [[theValue(count) should] equal:theValue(3)];
});

SPEC_END
