//
//  TECPullToRefreshStateSharedExampleSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshState.h"
#import "TECPullToRefreshStateContextProtocol.h"

SHARED_EXAMPLES_BEGIN(TECPullToRefreshStateSharedExampleSpec)

sharedExamplesFor(@"pull-to-refresh state", ^(NSDictionary *data) {
    __block Class sutClass;
    __block TECPullToRefreshState *sut;
    
    beforeAll(^{
        sutClass = data[@"class"];
    });
    
    let(contextMock, ^id{
        return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
    });
    
    describe(@"Constructor", ^{
        beforeEach(^{
            sut = [[sutClass alloc] initWithContext:contextMock];
        });
        
        it(@"Returns instance of state", ^{
            [[sut should] beKindOfClass:[TECPullToRefreshState class]];
        });
        
        it(@"Stores context in property", ^{
            [[(NSObject *)sut.context should] beIdenticalTo:contextMock];
        });
    });
    
    describe(@"Factory method", ^{
        beforeEach(^{
            sut = [sutClass stateWithContext:contextMock];
        });
        
        it(@"Returns instance of state", ^{
            [[sut should] beKindOfClass:[TECPullToRefreshState class]];
        });
        
        it(@"Stores context in property", ^{
            [[(NSObject *)sut.context should] beIdenticalTo:contextMock];
        });
    });
});

SHARED_EXAMPLES_END
