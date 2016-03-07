//
//  TECBaseModule.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewExtender.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

@implementation TECTableViewExtender

@dynamic extendedView;

+ (instancetype)extender {
    return [[self alloc] init];
}

@end

#pragma clang diagnostic pop
