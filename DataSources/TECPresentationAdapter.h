//
//  TECPresentationAdapter.h
//  DataSources
//
//  Created by Petro Korienev on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECContentProviderDelegate.h"
#import "TECContentProviderProtocol.h"

@class TECDelegateProxy;

@interface TECPresentationAdapter<ExtendedViewType, ExtenderType> : NSObject <TECContentProviderPresentationAdapterProtocol>

@property (nonatomic, strong, readonly) ExtendedViewType extendedView;
@property (nonatomic, strong, readonly) id <TECContentProviderProtocol> contentProvider;

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                           extendedView:(ExtendedViewType)extendedView
                              extenders:(NSArray<ExtenderType> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy;

@end
