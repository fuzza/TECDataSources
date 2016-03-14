//
//  TECBlankStateDecorator.m
//  DataSources
//
//  Created by Petro Korienev on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECBlankStateDecorator.h"
#import "TECPresentationAdapter.h"
#import "TECContentProviderProtocol.h"

@interface TECBlankStateDecorator () {
    __weak id<TECBlankStateDisplayProtocol> _display;
    UIView *_containerView;
}

@end

@implementation TECBlankStateDecorator

#pragma mark - Lifecycle

- (instancetype)initWithPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
                        blankStateDisplayer:(id<TECBlankStateDisplayProtocol>)blankStateDisplayer {
    self = [super initWithPresentationAdapter:presentationAdapter];
    if (self) {
        _display = blankStateDisplayer;
        [self initViewHierarchy];
        [self testDisplayability];
    }
    return self;
}

- (void)initViewHierarchy {
    UIScrollView *extendedView = self.presentationAdapter.extendedView;
    _containerView = [[UIView alloc] initWithFrame:extendedView.frame];
    _containerView.hidden = YES;
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [extendedView.superview insertSubview:_containerView aboveSubview:extendedView];
    [extendedView.superview addConstraints:@[equalWidth, equalHeight, centerX, centerY]];
}

#pragma mark - TECContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [super contentProviderDidReloadData:contentProvider];
    [self testDisplayability];
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [super contentProviderDidChangeContent:contentProvider];
    [self testDisplayability];
}

#pragma mark - Test displayability & display

- (void)testDisplayability {
    [self testAgainstBlankState];
    [self testAgainstNonBlankState];
}

- (void)testAgainstBlankState {
    if ([self.contentProvider numberOfSections] == 0) {
        BOOL shouldShow = [_display shouldShowBlankStateForPresentationAdapter:self.presentationAdapter];
        if (shouldShow) {
            _containerView.hidden = NO;
            [_display showBlankStateForPresentationAdapter:self.presentationAdapter containerView:_containerView];
        }
    }
}

- (void)testAgainstNonBlankState {
    if ([self.contentProvider numberOfSections] != 0) {
        BOOL shouldHide = [_display shouldHideBlankStateForPresentationAdapter:self.presentationAdapter];
        if (shouldHide) {
            _containerView.hidden = YES;
            [_display hideBlankStateForPresentationAdapter:self.presentationAdapter containerView:_containerView];
        }
    }
}

@end
