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
#import "TECScrollViewHelper.h"
#import "TECRefreshTransitionHelper.h"

@implementation TECPullToRefreshStateLoading

- (void)didAttach {
    CGFloat scrollPosition = self.context.scrollPosition;
    [TECScrollViewHelper modifyTopInset:self.context.pullToRefreshThreshold
                             scrollView:self.context.scrollView];
    [self.context.scrollView setContentOffset:CGPointMake(0, scrollPosition)];
    
    [self triggerLoading];
}

- (void)didScroll {
    CGFloat scrollPosition = [self.context scrollPosition];
    CGFloat threshold = [self.context pullToRefreshThreshold];
    UIScrollView *scrollView = [self.context scrollView];
    
    CGFloat topInset = 0;
    if(scrollPosition < 0) {
        topInset = MIN(-scrollPosition, threshold);
    }
    [TECScrollViewHelper modifyTopInset:topInset scrollView:scrollView];
}

- (TECPullToRefreshStateCode)code {
    return TECPullToRefreshStateCodeLoading;
}

#pragma mark - Private

- (void)triggerLoading {
    id <TECLoaderProtocol> loader = [self.context loader];
    __weak typeof(self) weakSelf = self;
    [loader reloadWithCompletionBlock:^(NSArray *result, NSError *error) {
        [TECRefreshTransitionHelper goToStateClass:[TECPullToRefreshStateClosing class] inContext:weakSelf.context];
    }];
}



@end
