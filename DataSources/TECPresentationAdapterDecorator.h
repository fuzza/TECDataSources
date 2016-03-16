//
//  TECPresentationAdapterDecorator.h
//  DataSources
//
//  Created by Petro Korienev on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECContentProviderDelegate.h"

@class TECPresentationAdapter;

@interface TECPresentationAdapterDecorator : NSProxy

@property (nonatomic, weak, readonly) id<TECContentProviderProtocol> contentProvider;
@property (nonatomic, strong, readonly) TECPresentationAdapter *presentationAdapter;

+ (id)decoratedInstanceOf:(TECPresentationAdapter *)presentationAdapter;
- (id)initWithPresentationAdapter:(TECPresentationAdapter *)presentationAdapter;

@end
