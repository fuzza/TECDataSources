//
//  TECPullToRefreshStateClosing.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshStateClosing.h"
#import "TECPullToRefreshStateInitial.h"
#import "TECPullToRefreshStateContextProtocol.h"
#import "TECScrollViewHelper.h"

@implementation TECPullToRefreshStateClosing

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeClosing;
}

- (void)didAttach {
    CGFloat animationDuration = [self.context animationDuration];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        [TECScrollViewHelper modifyTopInset:0 scrollView:weakSelf.context.scrollView];
    } completion:^(BOOL finished) {
        TECPullToRefreshStateInitial *initialState = [TECPullToRefreshStateInitial stateWithContext:weakSelf.context];
        [weakSelf.context setState:initialState];
    }];
}

@end