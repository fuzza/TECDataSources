//
//  TECPullToRefreshStateClosingSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/15/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshStateClosing.h"
#import "TECPullToRefreshStateInitial.h"
#import "TECPullToRefreshStateContextProtocol.h"

SPEC_BEGIN(TECPullToRefreshStateClosingSpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshStateClosing class]});

let(contextMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
});

let(sut, ^TECPullToRefreshStateClosing *{
    return [TECPullToRefreshStateClosing stateWithContext:contextMock];
});

let(scrollViewMock, ^id{
    return [UIScrollView nullMock];
});

it(@"Has closing code", ^{
    [[theValue(sut.code) should] equal:theValue(TECPullToRefreshStateCodeClosing)];
});

describe(@"Attach event", ^{
    let(scrollViewMock, ^id{
        return [UIScrollView mock];
    });
    
    beforeEach(^{
        [contextMock stub:@selector(scrollView) andReturn:scrollViewMock];
        [contextMock stub:@selector(animationDuration) andReturn:theValue(0.33)];
        
        [UIView stub:@selector(animateWithDuration:animations:completion:)];
    });
    
    it(@"Animates with contexts duration", ^{
        KWCaptureSpy *spy = [UIView captureArgument:@selector(animateWithDuration:animations:completion:) atIndex:0];
        [sut didAttach];
        
        [[spy.argument should] equal:theValue(0.33)];
    });
    
    it(@"Sets zero top inset inside animation block", ^{
        UIEdgeInsets initialInset = UIEdgeInsetsMake(60, 0, 80, 0);
        UIEdgeInsets expectedInset = UIEdgeInsetsMake(0, 0, 80, 0);
        
        KWCaptureSpy *spy = [UIView captureArgument:@selector(animateWithDuration:animations:completion:) atIndex:1];
        
        [scrollViewMock stub:@selector(contentInset) andReturn:theValue(initialInset)];
        [[scrollViewMock should] receive:@selector(setContentInset:) withArguments:theValue(expectedInset)];
        
        [sut didAttach];
        
        void(^animationBlock)() = (void(^)())spy.argument;
        animationBlock();
    });
    
    it(@"Sets initial state after animation completed", ^{
        id nextStateMock = [TECPullToRefreshStateInitial mock];
        [TECPullToRefreshStateInitial stub:@selector(stateWithContext:) andReturn:nextStateMock withArguments:contextMock];
        
        KWCaptureSpy *spy = [UIView captureArgument:@selector(animateWithDuration:animations:completion:) atIndex:2];
        
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        
        [sut didAttach];
        
        void(^completion)(BOOL) = (void(^)(BOOL))spy.argument;
        completion(YES);
    });
});


SPEC_END
