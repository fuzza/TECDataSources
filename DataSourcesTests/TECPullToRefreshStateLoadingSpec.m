//
//  TECPullToRefreshStateLoadingSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshStateLoading.h"
#import "TECPullToRefreshStateClosing.h"
#import "TECPullToRefreshStateContextProtocol.h"
#import "TECLoaderProtocol.h"

SPEC_BEGIN(TECPullToRefreshStateLoadingSpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshStateLoading class]});

let(contextMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
});

let(sut, ^TECPullToRefreshStateLoading *{
    return [TECPullToRefreshStateLoading stateWithContext:contextMock];
});

let(scrollViewMock, ^id{
    return [UIScrollView nullMock];
});

it(@"Has loading code", ^{
    [[theValue(sut.code) should] equal:theValue(TECPullToRefreshStateCodeLoading)];
});

describe(@"Attach event", ^{
    let(loaderMock, ^id{
        return [KWMock nullMockForProtocol:@protocol(TECLoaderProtocol)];
    });
    
    beforeEach(^{
        [contextMock stub:@selector(scrollView) andReturn:scrollViewMock];
        [contextMock stub:@selector(loader) andReturn:loaderMock];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(25)];
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(477)];
    });
    
    it(@"Sets top content inset", ^{
        UIEdgeInsets originInsets = UIEdgeInsetsMake(0, 0, 200, 0);
        UIEdgeInsets expectedInsets = UIEdgeInsetsMake(25, 0, 200, 0);
        [scrollViewMock stub:@selector(contentInset) andReturn:theValue(originInsets)];
        
        [[scrollViewMock should] receive:@selector(setContentInset:) withArguments:theValue(expectedInsets)];
        [sut didAttach];
    });
    
    it(@"Should re-set scroll position after changing inset", ^{
        [[scrollViewMock should] receive:@selector(setContentOffset:) withArguments:theValue(CGPointMake(0, 477))];
        [sut didAttach];
    });
    
    it(@"Triggers loader and sets closed state on completion", ^{
        id nextStateMock = [TECPullToRefreshStateClosing mock];
        [TECPullToRefreshStateClosing stub:@selector(stateWithContext:) andReturn:nextStateMock withArguments:contextMock];
        [[contextMock should] receive:@selector(setState:) withArguments:nextStateMock];
        
        KWCaptureSpy *reloadSpy = [loaderMock captureArgument:@selector(reloadWithCompletionBlock:) atIndex:0];
        
        [sut didAttach];
        TECLoaderCompletionBlock result = (TECLoaderCompletionBlock)reloadSpy.argument;
        result(@[], nil);
    });
});

describe(@"Scroll event", ^{
    void(^verifyInsets)(UIEdgeInsets,
                        CGFloat,
                        CGFloat,
                        UIEdgeInsets) =  ^(UIEdgeInsets initialInset,
                                           CGFloat threshold,
                                           CGFloat scrollPosition,
                                           UIEdgeInsets expectedInset) {
        [contextMock stub:@selector(scrollView) andReturn:scrollViewMock];
        [scrollViewMock stub:@selector(contentInset) andReturn:theValue(initialInset)];
        [contextMock stub:@selector(pullToRefreshThreshold) andReturn:theValue(threshold)];
        [contextMock stub:@selector(scrollPosition) andReturn:theValue(scrollPosition)];
        
        [[scrollViewMock should] receive:@selector(setContentInset:) withArguments:theValue(expectedInset)];
        [sut didScroll];
    };
    
    context(@"Scroll position is positive", ^{
        it(@"Sets zero top inset", ^{
            UIEdgeInsets initialInset = UIEdgeInsetsMake(25, 0, 130, 0);
            CGFloat threshold = 90;
            CGFloat scrollPosition = 15;
            UIEdgeInsets expectedInset = UIEdgeInsetsMake(0, 0, 130, 0);
            verifyInsets(initialInset, threshold, scrollPosition, expectedInset);
        });
    });
    
    context(@"Scroll position is zero", ^{
        it(@"Sets zero top inset", ^{
            UIEdgeInsets initialInset = UIEdgeInsetsMake(25, 0, 130, 0);
            CGFloat threshold = 90;
            CGFloat scrollPosition = 0;
            UIEdgeInsets expectedInset = UIEdgeInsetsMake(0, 0, 130, 0);
            verifyInsets(initialInset, threshold, scrollPosition, expectedInset);
        });
    });
    
    context(@"Scroll position is negative", ^{
        it(@"Sets mod of scroll position to top inset", ^{
            UIEdgeInsets initialInset = UIEdgeInsetsMake(0, 0, 150, 0);
            CGFloat threshold = 90;
            CGFloat scrollPosition = -40;
            UIEdgeInsets expectedInset = UIEdgeInsetsMake(40, 0, 150, 0);
            verifyInsets(initialInset, threshold, scrollPosition, expectedInset);
        });
        
        it(@"Doesn't set more than threshold to top inset", ^{
            UIEdgeInsets initialInset = UIEdgeInsetsMake(0, 0, 150, 0);
            CGFloat threshold = 90;
            CGFloat scrollPosition = -120;
            UIEdgeInsets expectedInset = UIEdgeInsetsMake(90, 0, 150, 0);
            verifyInsets(initialInset, threshold, scrollPosition, expectedInset);
        });
    });
});

SPEC_END
