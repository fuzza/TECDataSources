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
@property (nonatomic, weak, readwrite) id <TECPullToRefreshStateContextProtocol>context;
@end

@implementation TECPullToRefreshState

+ (instancetype)stateWithContext:(id<TECPullToRefreshStateContextProtocol>)context {
    return [[self alloc] initWithContext:context];
}

- (instancetype)initWithContext:(id<TECPullToRefreshStateContextProtocol>)context {
    self = [super init];
    if(self) {
        self.context = context;
    }
    return self;
}

#pragma mark - Events

- (void)didAttach {}

- (void)didScroll {}

- (void)didStartDragging {}

- (void)didRelease {}

- (void)didLoad {}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeUnknown;
}

@end
