//
//  TECPullToRefreshExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/11/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshExtender.h"
#import "TECPullToRefreshStateInitial.h"
#import "TECLoaderProtocol.h"
#import "TECPullToRefreshDisplayProtocol.h"
#import "TECScrollViewHelper.h"

SPEC_BEGIN(TECPullToRefreshExtenderSpec)

itBehavesLike(@"base extender", @{@"class" : [TECPullToRefreshExtender class]});

let(loaderMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECLoaderProtocol)];
});

let(displayMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECPullToRefreshDisplayProtocol)];
});

let(sut, ^TECPullToRefreshExtender *{
    return [[TECPullToRefreshExtender alloc] initWithThreshold:55
                                                       display:displayMock
                                                        loader:loaderMock];
});

describe(@"Init", ^{
    it(@"Returns new p-t-r extender", ^{
        [[sut should] beKindOfClass:[TECPullToRefreshExtender class]];
        [[sut should] conformToProtocol:@protocol(TECPullToRefreshStateContextProtocol)];
    });
});

describe(@"State context protocol", ^{
    it(@"Exposes loader passed on init", ^{
        [[(NSObject *)sut.loader should] beIdenticalTo:loaderMock];
    });
    
    it(@"Exposes offset passed on init as threshold", ^{
        [[theValue(sut.pullToRefreshThreshold) should] equal:theValue(55)];
    });
    
    it(@"Has animation duration set to 0.25s", ^{
        [[theValue(sut.animationDuration) should] equal:theValue(0.25)];
    });
    
    it(@"Exposes extended view and its content offset", ^{
        id scrollViewMock = [UIScrollView mock];
        [scrollViewMock stub:@selector(contentOffset) andReturn:theValue(CGPointMake(0, 30))];
        sut.extendedView = scrollViewMock;
        [[sut.scrollView should] beIdenticalTo:scrollViewMock];
        [[theValue(sut.scrollPosition) should] equal:theValue(30)];
    });
});

describe(@"Setup hook", ^{
    let(scrollViewMock, ^id{
        return [UIScrollView nullMock];
    });
    
    beforeEach(^{
        [sut stub:@selector(pullToRefreshThreshold) andReturn:theValue(85)];
        sut.extendedView = scrollViewMock;
    });
    
    it(@"Should create p-t-r view and set correct frame", ^{
        [sut stub:@selector(setState:)];
        [displayMock stub:@selector(setupWithContainerView:)];
        
        CGRect bounds = CGRectMake(0, 0, 333, 0);
        CGRect expectedFrame = CGRectMake(0, -85, 333, 85);

        [scrollViewMock stub:@selector(bounds) andReturn:theValue(bounds)];
        KWCaptureSpy *spy = [sut.extendedView captureArgument:@selector(addSubview:) atIndex:0];
        [sut didSetup];
        
        UIView *view = spy.argument;
        [[view should] beIdenticalTo:sut.pullToRefreshView];
        [[theValue(view.frame) should] equal:theValue(expectedFrame)];
        [[theValue(view.autoresizingMask & UIViewAutoresizingFlexibleWidth) should] beTrue];
    });
    
    it(@"Registers p-t-r view in presentation adapter", ^{
        [sut stub:@selector(setState:)];
        
        id viewMock = [UIView nullMock];
        [sut stub:@selector(pullToRefreshView) andReturn:viewMock];
        
        [[displayMock should] receive:@selector(setupWithContainerView:) withArguments:viewMock];
        [sut didSetup];
    });
    
    it(@"Sets initial state", ^{
        [displayMock stub:@selector(setupWithContainerView:)];
        
        id stateMock = [TECPullToRefreshStateInitial mock];
        [TECPullToRefreshStateInitial stub:@selector(stateWithContext:) andReturn:stateMock withArguments:sut];
        
        [[sut should] receive:@selector(setState:) withArguments:stateMock];
        [sut didSetup];
    });
});

describe(@"ScrollViewDelegate", ^{
    let(stateMock, ^id{
        return [TECPullToRefreshState mock];
    });
    
    let(scrollViewMock, ^id{
        return [UIScrollView mock];
    });
    
    beforeEach(^{
        [sut stub:@selector(state) andReturn:stateMock];
    });
    
    it(@"Forwards scroll events to state and sends progress to display", ^{
        [TECScrollViewHelper stub:@selector(scrollProgressForTopThreshold:scrollView:)
                        andReturn:theValue(0.1)];
        
        [[stateMock should] receive:@selector(didScroll)];
        [[displayMock should] receive:@selector(didChangeScrollProgress:) withArguments:theValue(0.1)];
        [sut scrollViewDidScroll:scrollViewMock];
    });
    
    it(@"Forwards dragging start to state", ^{
        [[stateMock should] receive:@selector(didStartDragging)];
        [sut scrollViewWillBeginDragging:scrollViewMock];
    });
    
    it(@"Forwards end dragging to state with decelerating", ^{
        [[stateMock should] receive:@selector(didRelease)];
        [sut scrollViewDidEndDragging:scrollViewMock willDecelerate:YES];
    });
    
    it(@"Forwards end dragging to state without decelerating", ^{
        [[stateMock should] receive:@selector(didRelease)];
        [sut scrollViewDidEndDragging:scrollViewMock willDecelerate:NO];
    });
});

describe(@"State change", ^{
    it(@"Changes state, attaches it and notify adapter", ^{
        id stateMock = [TECPullToRefreshState mock];
        [[stateMock should] receive:@selector(didAttach)];
        [[displayMock should] receive:@selector(didChangeState:) withArguments:stateMock];
        
        sut.state = stateMock;
        
        [[sut.state should] equal:stateMock];
    });
});

SPEC_END
