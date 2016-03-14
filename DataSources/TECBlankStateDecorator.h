//
//  TECBlankStateDecorator.h
//  DataSources
//
//  Created by Petro Korienev on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECPresentationAdapterDecorator.h"

@protocol TECBlankStateDisplayProtocol <NSObject>

- (BOOL)shouldShowBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter;
- (void)showBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
                               containerView:(UIView *)containerView;
- (BOOL)shouldHideBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter;
- (void)hideBlankStateForPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
                               containerView:(UIView *)containerView;

@end

@interface TECBlankStateDecorator : TECPresentationAdapterDecorator

- (instancetype)initWithPresentationAdapter:(TECPresentationAdapter *)presentationAdapter
                        blankStateDisplayer:(id<TECBlankStateDisplayProtocol>)blankStateDisplayer;

@end
