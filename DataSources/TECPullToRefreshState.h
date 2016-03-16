//
//  TECPullToRefreshState.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TECPullToRefreshStateCode) {
    TECPullToRefreshStateCodeUnknown = 0,
    TECPullToRefreshStateCodeInitial,
    TECPullToRefreshStateCodePulling,
    TECPullToRefreshStateCodeReady,
    TECPullToRefreshStateCodeLoading,
    TECPullToRefreshStateCodeClosing
};

@protocol TECPullToRefreshStateContextProtocol;

@interface TECPullToRefreshState : NSObject

@property (nonatomic, weak, readonly) id <TECPullToRefreshStateContextProtocol>context;

+ (instancetype)stateWithContext:(id<TECPullToRefreshStateContextProtocol>)context;
- (instancetype)initWithContext:(id<TECPullToRefreshStateContextProtocol>)context;

- (void)didAttach;
- (void)didScroll;
- (void)didStartDragging;
- (void)didRelease;
- (void)didLoad;

- (TECPullToRefreshStateCode)code;

@end
