//
//  TECReusableViewsFactory.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECReusableViewsFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECReusableViewsFactory ()

@property (nonatomic, readwrite) id<TECReusableViewRegistrationAdapterProtocol> registrationAdapter;

@end

@implementation TECReusableViewsFactory

- (instancetype)initWithRegistrationAdapter:(id<TECReusableViewRegistrationAdapterProtocol>)registrationAdapter {
    self = [super init];
    if(self) {
        self.registrationAdapter = registrationAdapter;
    }
    return self;
}

- (UIView *)viewForItem:(id)item
            atIndexPath:(NSIndexPath *)indexPath {
    [NSException raise:NSStringFromClass([self class]) format:@"Should be overriden in subclass"];
    return nil;
}

- (void)configureView:(UIView *)view
              forItem:(id)item
          atIndexPath:(NSIndexPath *)indexPath {
    [NSException raise:NSStringFromClass([self class]) format:@"Should be overriden in subclass"];
}

@end
