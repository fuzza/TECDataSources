//
//  TECScrollViewHelper.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECScrollViewHelper.h"

@implementation TECScrollViewHelper

+ (CGFloat)scrollProgressForTopThreshold:(CGFloat)threshold
                              scrollView:(UIScrollView *)scrollView {
    CGFloat progress = -scrollView.contentOffset.y / threshold;
    CGFloat roundedProgress = (NSInteger)(progress * 100 + 0.5) / 100.0;
    return MAX(MIN(roundedProgress, 1), 0);
}

+ (void)modifyTopInset:(CGFloat)topInset scrollView:(UIScrollView *)scrollView {
    UIEdgeInsets modifiedInset = scrollView.contentInset;
    modifiedInset.top = topInset;
    scrollView.contentInset = modifiedInset;
}

@end
