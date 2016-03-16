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

@property (nonatomic, weak) id<TECBlankStateDisplayProtocol> display;
@property (nonatomic, strong) UIView *containerView;

- (void)displayBlankStateIfNeeded;
- (void)showBlankStateIfNeeded;
- (void)hideBlankStateIfNeeded;

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
        [extendedViewMock stub:@selector(frame) andReturn:theValue(CGRectZero)];
        [tablePresentationAdapterMock stub:@selector(extendedView) andReturn:extendedViewMock];
        [tablePresentationAdapterMock stub:@selector(contentProvider) andReturn:contentProviderMock];
    };
    
    context(@"on initialization", ^() {
        beforeEach(beforeEachBlock);
        it(@"should set presentation adapter and contentProvider", ^() {
            TECBlankStateDecorator *decorator =
            [[TECBlankStateDecorator alloc] initWithPresentationAdapter:tablePresentationAdapterMock
                                                    blankStateDisplayer:displayMock];
            [[decorator.presentationAdapter should] beIdenticalTo:tablePresentationAdapterMock];
            [[contentProviderMock should] beIdenticalTo:decorator.contentProvider];
            [[displayMock should] equal:decorator.display];
            [[decorator.containerView should] beKindOfClass:[UIView class]];
        });
    });
    
    context(@"when testing displayability", ^{
        let(sut, ^TECBlankStateDecorator *{
            beforeEachBlock();
            return [[TECBlankStateDecorator alloc] initWithPresentationAdapter:tablePresentationAdapterMock
                                                           blankStateDisplayer:displayMock];
        });
        
        it(@"should test both blank and non-blank states", ^() {
            [sut showBlankStateIfNeeded];
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
                [sut showBlankStateIfNeeded];
            });
            
            context(@"when displayer allows show", ^() {
                beforeEach(^() {
                    beforeEachBlock1();
                    [displayMock stub:@selector(shouldShowBlankStateForPresentationAdapter:)
                            andReturn:theValue(YES)];
                });
                it(@"should call show on displayer", ^{
                    [[displayMock should] receive:@selector(showBlankStateForPresentationAdapter:containerView:) withArguments:tablePresentationAdapterMock, sut.containerView];
                    [sut showBlankStateIfNeeded];
                    [[theValue(sut.containerView.hidden) should] beNo];
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
                    [sut showBlankStateIfNeeded];
                    [[theValue(sut.containerView.hidden) should] beYes];
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
                [sut hideBlankStateIfNeeded];
            });
            
            context(@"when displayer disallows hide", ^() {
                beforeEach(^() {
                    beforeEachBlock1();
                    [displayMock stub:@selector(shouldHideBlankStateForPresentationAdapter:)
                            andReturn:theValue(YES)];
                });
                
                it(@"should call hide on displayer", ^{
                    [[displayMock should] receive:@selector(hideBlankStateForPresentationAdapter:containerView:) withArguments:tablePresentationAdapterMock, sut.containerView];
                    [sut hideBlankStateIfNeeded];
                    [[theValue(sut.containerView.hidden) should] beYes];
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
                    [[sut.containerView shouldNot] receive:@selector(setHidden:)];
                    [sut hideBlankStateIfNeeded];
                });
            });
        });
        
        it(@"should return correct instance from its decoratedInstanceOf method", ^() {
            [tablePresentationAdapterMock stub:@selector(contentProvider) andReturn:contentProviderMock];
            TECBlankStateDecorator *decorator = [TECBlankStateDecorator decoratedInstanceOf:tablePresentationAdapterMock
                                                                    withBlankStateDisplayer:displayMock];
            [[theValue([decorator isProxy]) should] beYes];
            [[[decorator presentationAdapter] should] equal:tablePresentationAdapterMock];
            [[(NSObject *)[decorator contentProvider] should] equal:[tablePresentationAdapterMock contentProvider]];
            [[displayMock should] equal:decorator.display];
            [[decorator.containerView should] beKindOfClass:[UIView class]];
        });
    });
});

SPEC_END