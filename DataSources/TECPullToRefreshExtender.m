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

@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) id <TECPullToRefreshPresentationAdapterProtocol> presentationAdapter;
@property (nonatomic, strong) id<TECLoaderProtocol> loader;
@end

@implementation TECPullToRefreshExtender

- (instancetype)initWithHeight:(CGFloat)height presentationAdapter:(id<TECPullToRefreshPresentationAdapterProtocol>)presentationAdapter loader:(id<TECLoaderProtocol>)loader {
    self = [super init];
    if(self) {
        self.offset = height;
        self.presentationAdapter = presentationAdapter;
        self.loader = loader;
    }
    return self;
}

- (void)didSetup {
    self.containerView = [UIView new];
    self.containerView.frame = CGRectMake(0, -self.offset, CGRectGetHeight(self.extendedView.bounds), self.offset);
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.extendedView addSubview:self.containerView];
    [self.presentationAdapter setupWithContainerView:self.containerView];
    
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
    NSLog(@"%@", @(state.code));
}

#pragma mark - TECPullToRefreshStateContextProtocol

- (CGFloat)pullToRefreshThreshold {
    return self.offset;
}

- (CGFloat)scrollPosition {
    return self.scrollView.contentOffset.y;
}

- (CGFloat)animationDuration {
    return 0.25;
}

- (UIScrollView *)scrollView {
    return self.extendedView;
}

- (UIView *)pullToRefreshView {
    return self.containerView;
}

@end
