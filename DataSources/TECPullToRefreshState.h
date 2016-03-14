//
//  TECPullToRefreshState.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECPullToRefreshStateContext;

@interface TECPullToRefreshState : NSObject

@property (nonatomic, weak, readonly) id <TECPullToRefreshStateContext>context;

- (instancetype)initWithContext:(id<TECPullToRefreshStateContext>)context;

- (void)didScroll;
- (void)didStartDragging;
- (void)didRelease;
- (void)didLoad;

@end
