//
//  TECPullToRefreshStateInitial.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshStateInitial.h"
#import "TECPullToRefreshStateContextProtocol.h"
#import "TECPullToRefreshStatePulling.h"
#import "TECRefreshTransitionHelper.h"

@implementation TECPullToRefreshStateInitial

- (void)didStartDragging {
    [TECRefreshTransitionHelper goToStateClass:[TECPullToRefreshStatePulling class] inContext:self.context];
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeInitial;
}

@end
