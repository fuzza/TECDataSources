//
//  TECDummyLoader.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECDummyLoader.h"

@interface TECDummyLoader ()

@property (nonatomic, strong) TECMemoryContentProvider *contentProvider;
@property (nonatomic, assign, readwrite) TECLoaderState state;

@end

@implementation TECDummyLoader

- (instancetype)initWithContentProvider:(TECMemoryContentProvider *)contentProvider {
    self = [super init];
    if(self) {
        self.contentProvider = contentProvider;
        self.state = TECLoaderStateReady;
    }
    return self;
}

- (void)reloadWithSuccess:(TECLoaderResultBlock)successBlock error:(TECLoaderErrorBlock)errorBlock {
    self.state = TECLoaderStateReloading;
    [self simulateRequestWithSuccess:successBlock];
}

- (void)loadMoreWithSuccess:(TECLoaderResultBlock)successBlock error:(TECLoaderErrorBlock)errorBlock {
    if(self.state == TECLoaderStateReloading) {
        return;
    }
    self.state = TECLoaderStateLoadingMore;
    [self simulateRequestWithSuccess:successBlock];
}

- (void)simulateRequestWithSuccess:(TECLoaderResultBlock)successBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.contentProvider reloadDataSourceWithCompletion:nil];
        weakSelf.state = TECLoaderStateReady;
        if(successBlock) {
            successBlock(@[]);
        }
    });
}

- (void)cancelCurrentLoading {
    self.state = TECLoaderStateReady;
}

@end
