//
//  TECPullToRefreshStateSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPullToRefreshState.h"


SPEC_BEGIN(TECPullToRefreshStateSpec)

itBehavesLike(@"pull-to-refresh state", @{@"class" : [TECPullToRefreshState class]});

SPEC_END
