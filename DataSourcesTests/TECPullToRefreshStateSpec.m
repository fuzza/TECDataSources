//
//  TECPullToRefreshStateSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshState.h"
#import "TECPullToRefreshStateContextProtocol.h"

SPEC_BEGIN(TECPullToRefreshStateSpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshState class]});

let(contextMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
});

let(sut, ^TECPullToRefreshState *{
    return [TECPullToRefreshState stateWithContext:contextMock];
});

it(@"Has unknown code", ^{
    [[theValue(sut.code) should] equal:theValue(TECPullToRefreshStateCodeUnknown)];
});

SPEC_END
