//
//  TECBackgroundContextObjectMutator.m
//  DataSources
//
//  Created by Petro Korienev on 2/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECBackgroundContextObjectMutator.h"

@interface TECBackgroundContextObjectMutator ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation TECBackgroundContextObjectMutator

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [self init];
    if (self) {
        self.context = context;
    }
    return self;
}

@end
