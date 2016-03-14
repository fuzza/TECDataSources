//
//  TECPullToRefreshExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECExtender.h"

typedef void(^TECPullToRefreshActionHandler)();

@protocol TECPullToRefreshPresentationAdapterProtocol;

@interface TECPullToRefreshExtender : TECExtender

- (instancetype)initWithHeight:(CGFloat)height presentationAdapter:(id<TECPullToRefreshPresentationAdapterProtocol>)presentationAdapter actionHandler:(TECPullToRefreshActionHandler)actionHandler;

- (void)stop;

@end
