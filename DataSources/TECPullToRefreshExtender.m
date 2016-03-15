//
//  TECPullToRefreshExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshExtender.h"
#import "TECPullToRefreshStateInitial.h"
#import "TECPullToRefreshPresentationAdapterProtocol.h"
#import "TECLoaderProtocol.h"

@interface TECPullToRefreshExtender ()

@property (nonatomic, strong) UIView *pullToRefreshView;
@property (nonatomic, assign) CGFloat pullToRefreshThreshold;
@property (nonatomic, strong) id<TECLoaderProtocol> loader;

@property (nonatomic, strong) id <TECPullToRefreshPresentationAdapterProtocol> presentationAdapter;

@end

@implementation TECPullToRefreshExtender

- (instancetype)initWithHeight:(CGFloat)height presentationAdapter:(id<TECPullToRefreshPresentationAdapterProtocol>)presentationAdapter loader:(id<TECLoaderProtocol>)loader {
    self = [super init];
    if(self) {
        self.pullToRefreshThreshold = height;
        self.presentationAdapter = presentationAdapter;
        self.loader = loader;
    }
    return self;
}

- (void)didSetup {
    [self setupContainerView];
    [self setupPresentationAdapter];
    [self setupInitialState];
}

- (void)setupContainerView {
    CGRect containerFrame = CGRectMake(0,
                                       -self.pullToRefreshThreshold,
                                       CGRectGetWidth(self.extendedView.bounds),
                                       self.pullToRefreshThreshold);
    self.pullToRefreshView = [[UIView alloc] initWithFrame:containerFrame];
    self.pullToRefreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.extendedView addSubview:self.pullToRefreshView];
}

- (void)setupPresentationAdapter {
    [self.presentationAdapter setupWithContainerView:self.pullToRefreshView];
}

- (void)setupInitialState {
    self.state = [TECPullToRefreshStateInitial stateWithContext:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.state didScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.state didStartDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.state didRelease];
}

#pragma mark - State machine

- (void)setState:(TECPullToRefreshState *)state {
    _state = state;
    [_state didAttach];
    [self.presentationAdapter didChangeState:_state];
}

#pragma mark - TECPullToRefreshStateContextProtocol

- (CGFloat)scrollPosition {
    return self.scrollView.contentOffset.y;
}

- (CGFloat)animationDuration {
    return 0.25;
}

- (UIScrollView *)scrollView {
    return self.extendedView;
}

@end
