//
//  TECBlankStateDecoratorSpec.m
//  DataSources
//
//  Created by Petro Korienev on 3/16/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECBlankStateDecorator.h"
#import "TECTableViewPresentationAdapter.h"

@interface TECBlankStateDecorator (Test)

- (void)initViewHierarchy;
- (void)testDisplayability;
- (void)testAgainstBlankState;
- (void)testAgainstNonBlankState;

@end

SPEC_BEGIN(TECBlankStateDecoratorSpec)

let(tablePresentationAdapterMock, ^TECTableViewPresentationAdapter *{return [TECTableViewPresentationAdapter nullMock];});
let(contentProviderMock, ^KWMock<TECContentProviderProtocol> *{return [KWMock nullMockForProtocol:@protocol(TECContentProviderProtocol)];});
let(displayMock, ^KWMock<TECBlankStateDisplayProtocol> *{return [KWMock nullMockForProtocol:@protocol(TECBlankStateDisplayProtocol)];});

describe(@"TECBlankStateDecorator", ^() {
    itBehavesLike(@"TECPresentationAdapterDecorator", @{@"class" : [TECBlankStateDecorator class]});
    
    void (^beforeEachBlock)() = ^() {
        UIView *extendedViewSuperviewMock = [UIView nullMock];
        UIView *extendedViewMock = [UIView nullMock];
        [extendedViewMock stub:@selector(superview) andReturn:extendedViewSuperviewMock];
        [tablePresentationAdapterMock stub:@selector(extendedView) andReturn:extendedViewMock];
        [tablePresentationAdapterMock stub:@selector(contentProvider) andReturn:contentProviderMock];
    };
    
    context(@"on initialization", ^() {
        beforeEach(beforeEachBlock);
        it(@"should set presentation adapter and contentProvider", ^() {
            TECBlankStateDecorator *decorator = [[TECBlankStateDecorator alloc] initWithPresentationAdapter:tablePresentationAdapterMock
                                                                                        blankStateDisplayer:displayMock];
            [[decorator.presentationAdapter should] beIdenticalTo:tablePresentationAdapterMock];
            [[contentProviderMock should] beIdenticalTo:decorator.contentProvider];
        });
    });
    
    context(@"when testing displayability", ^{
        let(sut, ^TECBlankStateDecorator *{
            beforeEachBlock();
            return [[TECBlankStateDecorator alloc] initWithPresentationAdapter:tablePresentationAdapterMock
                                                           blankStateDisplayer:displayMock];
        });
        
        it(@"should test both blank and non-nlank states", ^() {
            [sut testDisplayability];
        });
        
        context(@"when content provider is empty", ^(){
            void (^beforeEachBlock1)() = ^() {
                beforeEachBlock();
                [contentProviderMock stub:@selector(numberOfSections) andReturn:theValue(0)];
            };
            beforeEach(beforeEachBlock1);
            it(@"should ask displayer for show", ^() {
                [[displayMock should] receive:@selector(shouldShowBlankStateForPresentationAdapter:)
                                withArguments:tablePresentationAdapterMock];
                [sut testDisplayability];
            });
            
            context(@"when displayer allows show", ^() {
                beforeEach(^() {
                    beforeEachBlock1();
                    [displayMock stub:@selector(shouldShowBlankStateForPresentationAdapter:)
                            andReturn:theValue(YES)];
                });
                it(@"should call show on displayer", ^{
                    [[displayMock should] receive:@selector(showBlankStateForPresentationAdapter:containerView:)];
                    [sut testDisplayability];
                });
            });
            
            context(@"when displayer disallows show", ^() {
                beforeEach(^() {
                    beforeEachBlock1();
                    [displayMock stub:@selector(shouldShowBlankStateForPresentationAdapter:)
                            andReturn:theValue(NO)];
                });
                
                it(@"should not call show on displayer", ^{
                    [[displayMock shouldNot] receive:@selector(showBlankStateForPresentationAdapter:containerView:)];
                    [sut testDisplayability];
                });
            });
        });
        
        context(@"when content provider is not empty", ^(){
            void (^beforeEachBlock1)() = ^() {
                beforeEachBlock();
                [contentProviderMock stub:@selector(numberOfSections) andReturn:theValue(1)];
            };
            beforeEach(beforeEachBlock1);
            it(@"should ask displayer for hide", ^() {
                [[displayMock should] receive:@selector(shouldHideBlankStateForPresentationAdapter:)
                                withArguments:tablePresentationAdapterMock];
                [sut testDisplayability];
            });
            
            context(@"when displayer disallows hide", ^() {
                beforeEach(^() {
                    beforeEachBlock1();
                    [displayMock stub:@selector(shouldHideBlankStateForPresentationAdapter:)
                            andReturn:theValue(YES)];
                });
                it(@"should call hide on displayer", ^{
                    [[displayMock should] receive:@selector(hideBlankStateForPresentationAdapter:containerView:)];
                    [sut testDisplayability];
                });
            });
            
            context(@"when displayer disallows hide", ^() {
                beforeEach(^() {
                    beforeEachBlock1();
                    [displayMock stub:@selector(shouldHideBlankStateForPresentationAdapter:)
                            andReturn:theValue(NO)];
                });
                
                it(@"should not call hide on displayer", ^{
                    [[displayMock shouldNot] receive:@selector(hideBlankStateForPresentationAdapter:containerView:)];
                    [sut testDisplayability];
                });
            });
        });
    });
});

SPEC_END