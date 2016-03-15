//
//  TECScrollViewHelper.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECScrollViewHelper.h"

@implementation TECScrollViewHelper

+ (void)modifyTopInset:(CGFloat)topInset scrollView:(UIScrollView *)scrollView {
    UIEdgeInsets modifiedInset = scrollView.contentInset;
    modifiedInset.top = topInset;
    scrollView.contentInset = modifiedInset;
}

@end
