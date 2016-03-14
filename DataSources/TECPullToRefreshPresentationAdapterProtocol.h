//
//  TECPullToRefreshPresentationAdapterProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TECPullToRefreshState) {
    TECPullToRefreshStateInitial,
    TECPullToRefreshStatePulling,
    TECPullToRefreshStateReady,
    TECPullToRefreshStateLoading,
    TECPullToRefreshStateClosing
};

@protocol TECPullToRefreshPresentationAdapterProtocol <NSObject>

- (void)setupWithContainerView:(UIView *)containerView;

- (void)didChangeScrollProgress:(CGFloat)progress;
- (void)didChangeState:(TECPullToRefreshState)state;

@end
