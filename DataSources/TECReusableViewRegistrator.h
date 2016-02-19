//
//  TECCellRegistrator.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECReusableViewRegistratorProtocol.h"

typedef Class(^TECReusableViewRegistratorClassHandler)(id item, NSIndexPath *indexPath);
typedef NSString *(^TECReusableViewRegistratorIdentifierHandler)(Class viewClass, id item, NSIndexPath *indexPath);

@interface TECReusableViewRegistrator : NSObject <TECReusableViewRegistratorProtocol>

@property (nonatomic, strong) TECReusableViewRegistratorClassHandler classHandler;
@property (nonatomic, strong) TECReusableViewRegistratorIdentifierHandler identifierHandler;

@end
