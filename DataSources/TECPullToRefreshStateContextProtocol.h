//
//  TECPullToRefreshStateContext.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TECPullToRefreshState;
@protocol TECLoaderProtocol;

@protocol TECPullToRefreshStateContextProtocol <NSObject>

- (void)setState:(TECPullToRefreshState *)state;

- (UIScrollView *)scrollView;
- (UIView *)pullToRefreshView;

- (CGFloat)pullToRefreshThreshold;
- (CGFloat)animationDuration;

- (id<TECLoaderProtocol>)loader;

@end
