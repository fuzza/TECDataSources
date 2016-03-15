//
//  TECPullToRefreshTransitionHelper.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECRefreshTransitionHelper.h"
#import "TECPullToRefreshStateContextProtocol.h"

@implementation TECRefreshTransitionHelper

+ (void)goToStateClass:(Class)stateClass
                       inContext:(id <TECPullToRefreshStateContextProtocol>)context {
    if([stateClass isSubclassOfClass:[TECPullToRefreshState class]]) {
        TECPullToRefreshState *state = [stateClass stateWithContext:context];
        [context setState:state];
    }
}

@end
