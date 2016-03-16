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

@implementation TECPullToRefreshStatePulling

- (void)didRelease {
    TECPullToRefreshStateClosing *closingState = [TECPullToRefreshStateClosing stateWithContext:self.context];
    [self.context setState:closingState];
}

- (void)didScroll {
    CGFloat scrollPosition = [self.context scrollPosition];
    CGFloat threshold = [self.context pullToRefreshThreshold];
    if(scrollPosition <= -threshold) {
        TECPullToRefreshStateReady *readyState = [TECPullToRefreshStateReady stateWithContext:self.context];
        [self.context setState:readyState];
    }
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodePulling;
}

@end
