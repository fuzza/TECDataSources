//
//  TECPullToRefreshExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshExtender.h"
#import "TECPullToRefreshPresentationAdapterProtocol.h"

@interface TECPullToRefreshExtender ()

@property (nonatomic, strong, readwrite) UIView *containerView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) TECPullToRefreshState state;
@property (nonatomic, strong) id <TECPullToRefreshPresentationAdapterProtocol> presentationAdapter;
@property (nonatomic, strong) TECPullToRefreshActionHandler actionHandler;
@end

@implementation TECPullToRefreshExtender

- (instancetype)initWithHeight:(CGFloat)height presentationAdapter:(id<TECPullToRefreshPresentationAdapterProtocol>)presentationAdapter actionHandler:(TECPullToRefreshActionHandler)actionHandler {
    self = [super init];
    if(self) {
        self.offset = height;
        self.presentationAdapter = presentationAdapter;
        self.state = TECPullToRefreshStateInitial;
        self.actionHandler = actionHandler;
    }
    return self;
}

- (void)didSetup {
    self.containerView = [UIView new];
    self.containerView.frame = CGRectMake(0, -self.offset, CGRectGetHeight(self.extendedView.bounds), self.offset);
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.extendedView addSubview:self.containerView];
    [self.presentationAdapter setupWithContainerView:self.containerView];
}

- (void)stop {
    [self toClosing];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    switch (self.state) {
        case TECPullToRefreshStatePulling: {
            if(scrollView.contentOffset.y <= -self.offset) {
                self.state = TECPullToRefreshStateReady;
            }
        }
            break;
        case TECPullToRefreshStateReady: {
            if(scrollView.contentOffset.y > -self.offset) {
                self.state = TECPullToRefreshStatePulling;
            }
        }
            break;
        case TECPullToRefreshStateLoading: {
            if(scrollView.contentOffset.y >= 0 )
                scrollView.contentInset = UIEdgeInsetsZero;
            else
                scrollView.contentInset = UIEdgeInsetsMake(MIN( -scrollView.contentOffset.y, self.offset), 0, 0, 0 );       }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    switch (self.state) {
        case TECPullToRefreshStatePulling: {
            [self toClosing];
        }
            break;
        case TECPullToRefreshStateReady: {
            [self toLoading];
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    switch (self.state) {
        case TECPullToRefreshStateInitial: {
            self.state = TECPullToRefreshStatePulling;
        }
            break;
        default:
            break;
    }
}

- (void)setState:(TECPullToRefreshState)state {
    _state = state;
    [self.presentationAdapter didChangeState:state];
    NSLog(@"%@", @(state));
}

#pragma mark - State machine

- (void)toLoading {
    self.state = TECPullToRefreshStateLoading;
    self.extendedView.contentInset = UIEdgeInsetsMake(self.offset, 0, 0, 0);
    self.extendedView.contentOffset = CGPointMake(0, self.extendedView.contentOffset.y-self.offset);
    
    if(self.actionHandler) {
        self.actionHandler();
    }
}

- (void)toClosing {
    self.state = TECPullToRefreshStateClosing;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.extendedView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished) {
        weakSelf.state = TECPullToRefreshStateInitial;
    }];
}

@end
