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

@implementation TECPullToRefreshStateReady

- (void)didRelease {
    TECPullToRefreshStateLoading *loadingState = [TECPullToRefreshStateLoading stateWithContext:self.context];
    [self.context setState:loadingState];
}

- (void)didScroll {
    CGFloat scrollPosition = [self.context scrollPosition];
    CGFloat threshold = [self.context pullToRefreshThreshold];
    if(scrollPosition > -threshold) {
        TECPullToRefreshStatePulling *pullingState = [TECPullToRefreshStatePulling stateWithContext:self.context];
        [self.context setState:pullingState];
    }
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeReady;
}

@end
