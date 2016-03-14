//
//  TECBlankStateTextDisplay.m
//  DataSources
//
//  Created by Petro Korienev on 3/16/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECBlankStateTextDisplay.h"

@interface TECBlankStateTextDisplay ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation TECBlankStateTextDisplay

#pragma mark - Lifecycle

- (instancetype)initWithText:(NSString *)text {
    self = [self init];
    if (self) {
        self.text = text;
    }
    return self;
}

#pragma mark - TECBlankStateDisplayProtocol

- (BOOL)shouldShowBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter {
    return YES;
}

- (BOOL) shouldHideBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter {
    return YES;
}

- (void)showBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
                               containerView:(UIView *)containerView {
    self.textLabel = [UILabel new];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.text = self.text;
    NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [containerView addSubview:self.textLabel];
    [containerView addConstraints:@[equalWidth, equalHeight, centerX, centerY]];
}

- (void)hideBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
                               containerView:(UIView *)containerView {
    [self.textLabel removeFromSuperview];
    self.textLabel = nil;
}

@end
