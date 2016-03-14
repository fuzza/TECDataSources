//
//  TECLoadMoreProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECLoaderProtocol.h"

@protocol TECLoadMoreProtocol <TECLoaderProtocol>

- (void)loadMoreWithCompletionBlock:(TECLoaderCompletionBlock)completionBlock;

@end
