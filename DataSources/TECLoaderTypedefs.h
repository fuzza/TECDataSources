//
//  TECLoaderTypedefs.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, TECLoaderState) {
    TECLoaderStateUnknown = 0,
    TECLoaderStateReady,
    TECLoaderStateReloading,
    TECLoaderStateLoadingMore,
    TECLoaderStateFailed
};

typedef void(TECLoaderResultBlock)(NSArray *result);
typedef void(TECLoaderErrorBlock)(NSError *error);
