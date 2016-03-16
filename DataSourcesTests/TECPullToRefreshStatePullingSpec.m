//
//  TECPullToRefreshStatePullingSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshStatePulling.h"
#import "TECPullToRefreshStateClosing.h"
#import "TECPullToRefreshStateReady.h"
#import "TECPullToRefreshStateContextProtocol.h"

SPEC_BEGIN(TECPullToRefreshStatePullingSpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshStatePulling class]});

let(contextMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
});

let(sut, ^TECPullToRefreshStatePulling *{
    return [TECPullToRefreshStatePulling stateWithContext:contextMock];
});

it(@"Has pulling code", ^{
    [[theValue(sut.code) should] equal:theValue(TECPullToRefreshStateCodePulling)];
});

describe(@"Release event", ^{
    let(nextStateMock, ^id{
        return [TECPullToRefreshStateClosing mock];
    });
    
    beforeEach(^{
        [TECPullToRefreshStateClosing stub:@selector(stateWithContext:) andReturn:nextStateMock withArguments:contextMock];
    });
    
    it(@"Sets closing state to the context", ^{
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        [sut didRelease];
    });
});

describe(@"Scroll event", ^{
    let(nextStateMock, ^id{
        return [TECPullToRefreshStateReady mock];
    });
    
    beforeEach(^{
        [TECPullToRefreshStateReady stub:@selector(stateWithContext:) andReturn:nextStateMock withArguments:contextMock];
    });
    
    it(@"Sets ready state if scrolled below threshold", ^{
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(-45)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(30)];
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        [sut didScroll];
    });
    
    it(@"Sets ready state if scrolled to threshold", ^{
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(-30)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(30)];
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        [sut didScroll];
    });
    
    it(@"Doesn't change state if scrolled above threshold", ^{
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(-29)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(30)];
        [[contextMock shouldNot] receive:@selector(setState:)];
        [sut didScroll];
    });
});

SPEC_END
