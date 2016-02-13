//
//  TECMainContextObjectGetter.h
//  DataSources
//
//  Created by Petro Korienev on 2/11/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TECFetchedResultsControllerContentProviderGetter.h"

@interface TECMainContextObjectGetter : NSObject <TECFetchedResultsControllerContentProviderGetter>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
