//
//  TECPullToRefreshExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECExtender.h"
#import "TECPullToRefreshStateContextProtocol.h"

typedef void(^TECPullToRefreshActionHandler)();

@protocol TECPullToRefreshDisplayProtocol;
@protocol TECLoaderProtocol;

@interface TECPullToRefreshExtender : TECExtender <TECPullToRefreshStateContextProtocol>

@property (nonatomic, strong) TECPullToRefreshState *state;

- (instancetype)initWithThreshold:(CGFloat)threshold
                          display:(id<TECPullToRefreshDisplayProtocol>)presentationAdapter
                           loader:(id<TECLoaderProtocol>)loader;

@end
