//
//  TECContentProviderDelegate.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECContentProviderProtocol;

@protocol TECContentProviderPresentationAdapterProtocol <NSObject>

- (void)contentProviderDidReloadData:(id <TECContentProviderProtocol>)contentProvider;

@end
