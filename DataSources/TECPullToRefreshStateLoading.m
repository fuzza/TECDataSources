//
//  TECPullToRefreshStateLoading.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPullToRefreshStateLoading.h"
#import "TECPullToRefreshStateClosing.h"
#import "TECPullToRefreshStateContextProtocol.h"
#import "TECLoaderProtocol.h"

@implementation TECPullToRefreshStateLoading

- (void)didAttach {
    [self setupTopScrollViewInset:[self.context pullToRefreshThreshold]];
    [self triggerLoading];
}

- (void)didScroll {
    CGFloat scrollPosition = [self.context scrollPosition];
    CGFloat threshold = [self.context pullToRefreshThreshold];
    
    if(scrollPosition >= 0) {
        [self setupTopScrollViewInset:0];
    } else {
        [self setupTopScrollViewInset:MIN(-scrollPosition, threshold)];
    }
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeLoading;
}

#pragma mark - Private

- (void)setupTopScrollViewInset:(CGFloat)topInset {
    UIScrollView *scrollView = [self.context scrollView];
    UIEdgeInsets modifiedInset = scrollView.contentInset;
    modifiedInset.top = topInset;
    scrollView.contentInset = modifiedInset;
}

- (void)triggerLoading {
    id <TECLoaderProtocol> loader = [self.context loader];
    __weak typeof(self) weakSelf = self;
    [loader reloadWithCompletionBlock:^(NSArray *result, NSError *error) {
        TECPullToRefreshStateClosing *closingState = [TECPullToRefreshStateClosing stateWithContext:weakSelf.context];
        [weakSelf.context setState:closingState];
    }];
}



@end
