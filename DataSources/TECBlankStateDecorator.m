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

@interface TECBlankStateDecorator ()

@property (nonatomic, weak) id<TECBlankStateDisplayProtocol> display;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation TECBlankStateDecorator

#pragma mark - Lifecycle

+ (id)decoratedInstanceOf:(TECPresentationAdapter *)presentationAdapter
  withBlankStateDisplayer:(id<TECBlankStateDisplayProtocol>)blankStateDisplayer {
    return [[self alloc] initWithPresentationAdapter:presentationAdapter blankStateDisplayer:blankStateDisplayer];
}

- (id)initWithPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
              blankStateDisplayer:(id<TECBlankStateDisplayProtocol>)blankStateDisplayer {
    self = [super initWithPresentationAdapter:presentationAdapter];
    if (self) {
        self.display = blankStateDisplayer;
        [self initViewHierarchy];
        [self displayBlankStateIfNeeded];
    }
    return self;
}

- (void)initViewHierarchy {
    UIScrollView *extendedView = self.presentationAdapter.extendedView;
    self.containerView = [[UIView alloc] initWithFrame:extendedView.frame];
    self.containerView.hidden = YES;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:extendedView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [extendedView.superview insertSubview:self.containerView aboveSubview:extendedView];
    [extendedView.superview addConstraints:@[equalWidth, equalHeight, centerX, centerY]];
}

#pragma mark - TECContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidReloadData:)]) {
        [self.presentationAdapter contentProviderDidReloadData:contentProvider];
    }
    [self displayBlankStateIfNeeded];
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    if ([self.presentationAdapter respondsToSelector:@selector(contentProviderDidChangeContent:)]) {
        [self.presentationAdapter contentProviderDidChangeContent:contentProvider];
    }
    [self displayBlankStateIfNeeded];
}

#pragma mark - Test displayability & display

- (void)displayBlankStateIfNeeded {
    [self showBlankStateIfNeeded];
    [self hideBlankStateIfNeeded];
}

- (void)showBlankStateIfNeeded {
    if ([self.contentProvider numberOfSections] == 0) {
        BOOL shouldShow = [self.display shouldShowBlankStateForPresentationAdapter:self.presentationAdapter];
        if (shouldShow) {
            self.containerView.hidden = NO;
            [self.display showBlankStateForPresentationAdapter:self.presentationAdapter containerView:self.containerView];
        }
    }
}

- (void)hideBlankStateIfNeeded {
    if ([self.contentProvider numberOfSections] != 0) {
        BOOL shouldHide = [self.display shouldHideBlankStateForPresentationAdapter:self.presentationAdapter];
        if (shouldHide) {
            self.containerView.hidden = YES;
            [self.display hideBlankStateForPresentationAdapter:self.presentationAdapter containerView:self.containerView];
        }
    }
}

@end
