//
//  TECPullToRefreshStateReady.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshStateReady.h"
#import "TECPullToRefreshStateLoading.h"
#import "TECPullToRefreshStatePulling.h"
#import "TECPullToRefreshStateContextProtocol.h"
#import "TECRefreshTransitionHelper.h"

@implementation TECPullToRefreshStateReady

- (void)didRelease {
    [TECRefreshTransitionHelper goToStateClass:[TECPullToRefreshStateLoading class]
                                     inContext:self.context];
}

- (void)didScroll {
    CGFloat scrollPosition = [self.context scrollPosition];
    CGFloat threshold = [self.context pullToRefreshThreshold];
    if(scrollPosition > -threshold) {
        [TECRefreshTransitionHelper goToStateClass:[TECPullToRefreshStatePulling class] inContext:self.context];
    }
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeReady;
}

@end
