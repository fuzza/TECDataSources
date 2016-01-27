//
//  TECCallbackExecutor.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECTableController.h"

@interface TECCallbackExecutor : NSObject

- (void)executeTableViewCompletionBlock:(TECTableCompletionBlock)completionBlock;

@end
