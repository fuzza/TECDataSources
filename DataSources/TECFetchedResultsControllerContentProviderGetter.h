//
//  TECFetchedResultsControllerContentProviderGetter.h
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^TECFetchedResultsControllerContentProviderGetterFetchResultBlock)(NSArray<NSManagedObject *> *objects, NSError *error);

@protocol TECFetchedResultsControllerContentProviderGetter <NSObject>

- (void)fetchItemsForFetchRequest:(NSFetchRequest *)fetchRequest
                        withBlock:(TECFetchedResultsControllerContentProviderGetterFetchResultBlock)block;
- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath;

@end
