//
//  CoreDataManager.h
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "TECFetchedResultsControllerContentProviderGetter.h"
#import "TECFetchedResultsControllerContentProviderMutator.h"

@interface CoreDataManager : NSObject

+ (instancetype)sharedObject;

- (void)setup;
- (void)cleanup;
- (id<TECFetchedResultsControllerContentProviderGetter>)createObjectGetter;
- (id<TECFetchedResultsControllerContentProviderMutator>)createObjectMutator;
- (NSFetchRequest *)createPersonFetchRequest;
- (NSFetchRequest *)createPersonOrderedFetchRequest;

@end
