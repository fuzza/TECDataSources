//
//  TECPullToRefreshStateInitialSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshStateInitial.h"
#import "TECPullToRefreshStatePulling.h"
#import "TECPullToRefreshStateContextProtocol.h"

SPEC_BEGIN(TECPullToRefreshStateInitialSpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshStateInitial class]});

let(contextMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
});

let(sut, ^TECPullToRefreshStateInitial *{
    return [TECPullToRefreshStateInitial stateWithContext:contextMock];
});

it(@"Has initial code", ^{
    [[theValue(sut.code) should] equal:theValue(TECPullToRefreshStateCodeInitial)];
});

describe(@"Drag event", ^{
    let(pullingStateMock, ^id{
        return [TECPullToRefreshStatePulling mock];
    });
    
    beforeEach(^{
        [TECPullToRefreshStatePulling stub:@selector(stateWithContext:) andReturn:pullingStateMock withArguments:contextMock];
    });
    
    it(@"Sets pulling state to the context", ^{
        [[contextMock should] receive:@selector(setState:) withArguments:pullingStateMock];
        [sut didStartDragging];
    });
});

SPEC_END
