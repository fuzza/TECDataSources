//
//  TECCallbackExecutor.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCallbackExecutor.h"

@implementation TECCallbackExecutor

- (void)executeTableViewCompletionBlock:(TECTableCompletionBlock)completionBlock {
    if(!completionBlock) {
        return;
    }
    
    if([NSThread isMainThread]) {
        completionBlock();
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock();
    });
}

@end
