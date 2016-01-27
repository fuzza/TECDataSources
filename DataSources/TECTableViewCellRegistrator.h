//
//  TECTableViewCellRegistrator.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECTableViewCellRegistratorProtocol.h"

typedef Class(^TECTableViewCellClassHandler)(id item, NSIndexPath *indexPath);
typedef NSString *(^TECTableViewCellReuseIdHandler)(Class cellClass, id item, NSIndexPath *indexPath);

@interface TECTableViewCellRegistrator : NSObject <TECTableViewCellRegistratorProtocol>

- (instancetype)initWithClassHandler:(TECTableViewCellClassHandler)classHandler
                      reuseIdHandler:(TECTableViewCellReuseIdHandler)reuseIdHandler;

@end
