//
//  TECPullToRefreshState.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshState.h"
#import "TECPullToRefreshStateContextProtocol.h"

@interface TECPullToRefreshState ()
@property (nonatomic, weak, readwrite) id <TECPullToRefreshStateContext>context;
@end

@implementation TECPullToRefreshState

- (instancetype)initWithContext:(id<TECPullToRefreshStateContext>)context {
    self = [super init];
    if(self) {
        self.context = context;
    }
    return self;
}

- (void)didScroll {
    
}

- (void)didStartDragging {
    
}

- (void)didRelease {
    
}

- (void)didLoad {
    
}

@end
