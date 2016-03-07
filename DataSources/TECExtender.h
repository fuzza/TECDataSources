//
//  TECExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/7/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECContentProviderProtocol;

@interface TECExtender : NSObject <UIScrollViewDelegate>

@property (nonatomic, weak) id<TECContentProviderProtocol> contentProvider;
@property (nonatomic, weak) UIScrollView *extendedView;

@end
