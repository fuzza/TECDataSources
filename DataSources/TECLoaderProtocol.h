//
//  TECLoaderProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECLoaderTypedefs.h"

@protocol TECLoaderProtocol <NSObject>

@property (nonatomic, assign, readonly) TECLoaderState state;

- (void)reloadWithSuccess:(TECLoaderResultBlock)successBlock
                    error:(TECLoaderErrorBlock)errorBlock;

- (void)cancelCurrentLoading;

@end
