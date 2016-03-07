//
//  TECPresentationAdapterProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/7/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECContentProviderDelegate.h"

@class TECExtender;

@protocol TECPresentationAdapterProtocol <TECContentProviderPresentationAdapterProtocol>

@property (nonatomic, strong, readonly) UIScrollView *extendedView;
- (void)attachExtender:(TECExtender *)extender;

@end
