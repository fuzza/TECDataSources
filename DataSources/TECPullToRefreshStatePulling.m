//
//  TECPullToRefreshStatePulling.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshStatePulling.h"
#import "TECPullToRefreshStateClosing.h"
#import "TECPullToRefreshStateReady.h"
#import "TECPullToRefreshStateContextProtocol.h"
#import "TECRefreshTransitionHelper.h"

@implementation TECPullToRefreshStatePulling

- (void)didRelease {
    [TECRefreshTransitionHelper goToStateClass:[TECPullToRefreshStateClosing class] inContext:self.context];
}

- (void)didScroll {
    CGFloat scrollPosition = [self.context scrollPosition];
    CGFloat threshold = [self.context pullToRefreshThreshold];
    if(scrollPosition <= -threshold) {
        [TECRefreshTransitionHelper goToStateClass:[TECPullToRefreshStateReady class] inContext:self.context];
    }
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodePulling;
}

@end
