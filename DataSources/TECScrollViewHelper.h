//
//  TECScrollViewHelper.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TECScrollViewHelper : NSObject

+ (CGFloat)scrollProgressForTopThreshold:(CGFloat)threshold
                              scrollView:(UIScrollView *)scrollView;

+ (void)modifyTopInset:(CGFloat)topInset scrollView:(UIScrollView *)scrollView;

@end
