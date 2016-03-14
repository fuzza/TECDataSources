//
//  TECDummyLoader.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECLoadMoreProtocol.h"
#import "TECMemoryContentProvider.h"

@interface TECDummyLoader : NSObject <TECLoadMoreProtocol>

- (instancetype)initWithContentProvider:(TECMemoryContentProvider *)contentProvider;

@end
