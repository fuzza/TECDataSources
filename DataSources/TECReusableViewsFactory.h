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

@interface TECReusableViewsFactory : NSObject <TECReusableViewFactoryProtocol>

- (instancetype)initWithRegistrationAdapter:(id<TECReusableViewRegistrationAdapterProtocol>)registrationAdapter;

@property (nonatomic, readonly) id <TECReusableViewRegistrationAdapterProtocol> registrationAdapter;

@end
