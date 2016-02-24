//
//  TECBlockOperation.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/23/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECBlockOperation.h"

@implementation TECBlockOperation

+ (instancetype)operation {
    return [self new];
}

- (void)start {
    for (void (^executionBlock)(void) in [self executionBlocks]) {
        executionBlock();
    }
}

@end
