//
//  TECPullToRefreshTransitionHelper.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECPullToRefreshState.h"

@protocol TECPullToRefreshStateContextProtocol;

@interface TECRefreshTransitionHelper : NSObject

+ (void)goToStateClass:(Class)stateClass
             inContext:(id <TECPullToRefreshStateContextProtocol>)context;

@end
