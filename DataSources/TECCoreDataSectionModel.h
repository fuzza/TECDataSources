//
//  TECCoreDataSectionModel.h
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TECSectionModelProtocol.h"

@interface TECCoreDataSectionModel : NSObject <TECSectionModelProtocol>

- (instancetype)initWithFetchedResultsSectionInfo:(id<NSFetchedResultsSectionInfo>)info;
@property (nonatomic, strong, readonly) id <NSFetchedResultsSectionInfo> info;

@end
