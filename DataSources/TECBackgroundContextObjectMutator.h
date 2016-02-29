//
//  TECBackgroundContextObjectMutator.h
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TECFetchedResultsControllerContentProviderMutator.h"


@interface TECBackgroundContextObjectMutator : NSObject <TECFetchedResultsControllerContentProviderMutator>

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
