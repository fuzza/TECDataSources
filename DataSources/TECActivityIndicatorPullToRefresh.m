//
//  TECActivityIndicatorPullToRefresh.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECActivityIndicatorPullToRefresh.h"
#import "TECPullToRefreshState.h"

@interface TECActivityIndicatorPullToRefresh ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation TECActivityIndicatorPullToRefresh

- (void)setupWithContainerView:(UIView *)containerView {
    self.containerView = containerView;
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicator.hidesWhenStopped = NO;
    [self.containerView addSubview:self.indicator];
    
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.containerView addConstraint:xCenterConstraint];
    
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:self.indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.containerView addConstraint:yCenterConstraint];
}

- (void)didChangeState:(TECPullToRefreshState *)state {
    switch (state.code) {
        case TECPullToRefreshStateCodeReady:
        case TECPullToRefreshStateCodeLoading:
            [self.indicator startAnimating];
            break;
        default:
            [self.indicator stopAnimating];
            break;
    }
}

- (void)didChangeScrollProgress:(CGFloat)progress {
    
}

@end
