//
//  TECReusableViewsFactory.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECReusableViewFactoryProtocol.h"

@protocol TECReusableViewRegistrationAdapterProtocol;

@interface TECReusableViewsFactory <ReusableViewType>: NSObject <TECReusableViewFactoryProtocol>

- (instancetype)initWithRegistrationAdapter:(id<TECReusableViewRegistrationAdapterProtocol>)registrationAdapter;

@property (nonatomic, readonly) id <TECReusableViewRegistrationAdapterProtocol> registrationAdapter;

- (ReusableViewType)viewForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (void)configureView:(ReusableViewType)view forItem:(id)item atIndexPath:(NSIndexPath *)indexPath;

@end
