//
//  TECPullToRefreshStateReadySpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshStateReady.h"
#import "TECPullToRefreshStateLoading.h"
#import "TECPullToRefreshStatePulling.h"
#import "TECPullToRefreshStateContextProtocol.h"

SPEC_BEGIN(TECPullToRefreshStateReadySpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshStateReady class]});

let(contextMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
});

let(sut, ^TECPullToRefreshStateReady *{
    return [TECPullToRefreshStateReady stateWithContext:contextMock];
});

it(@"Has ready code", ^{
    [[theValue(sut.code) should] equal:theValue(TECPullToRefreshStateCodeReady)];
});

describe(@"Release event", ^{
    let(nextStateMock, ^id{
        return [TECPullToRefreshStateLoading mock];
    });
    
    beforeEach(^{
        [TECPullToRefreshStateLoading stub:@selector(stateWithContext:) andReturn:nextStateMock withArguments:contextMock];
    });
    
    it(@"Sets loading state to the context", ^{
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        [sut didRelease];
    });
});

describe(@"Scroll event", ^{
    let(nextStateMock, ^id{
        return [TECPullToRefreshStateReady mock];
    });
    
    beforeEach(^{
        [TECPullToRefreshStatePulling stub:@selector(stateWithContext:) andReturn:nextStateMock withArguments:contextMock];
    });
    
    it(@"Sets pulling state if scrolled above threshold", ^{
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(-25)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(30)];
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        [sut didScroll];
    });
    
    it(@"Doesn't change state if scrolled to threshold", ^{
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(-14)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(14)];
        [[contextMock shouldNot] receive:@selector(setState:) withArguments:nextStateMock];
        [sut didScroll];
    });

    it(@"Doesn't change state if scrolled below threshold", ^{
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(-90)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(56)];
        [[contextMock shouldNot] receive:@selector(setState:)];
        [sut didScroll];
    });
});

SPEC_END
