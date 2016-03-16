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

@implementation TECPullToRefreshStateInitial

- (void)didStartDragging {
    TECPullToRefreshStatePulling *pullingState = [TECPullToRefreshStatePulling stateWithContext:self.context];
    [self.context setState:pullingState];
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeInitial;
}

@end
