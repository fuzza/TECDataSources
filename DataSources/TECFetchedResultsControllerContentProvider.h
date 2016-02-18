//
//  TECFetchedResultsControllerContentProvider.h
//  DataSources
//
//  Created by Petro Korienev on 2/13/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TECContentProviderProtocol.h"
#import "TECFetchedResultsControllerContentProviderGetter.h"
#import "TECFetchedResultsControllerContentProviderMutator.h"

@interface TECFetchedResultsControllerContentProvider : NSObject <TECContentProviderProtocol>

- (instancetype)initWithItemsGetter:(id <TECFetchedResultsControllerContentProviderGetter>)getter
                       itemsMutator:(id <TECFetchedResultsControllerContentProviderMutator>)mutator
                       fetchRequest:(NSFetchRequest *)fetchRequest
                 sectionNameKeyPath:(NSString *)sectionNameKeyPath;

- (void)setCurrentRequest:(NSFetchRequest *)currentRequest; // This will trigger reload
- (NSFetchRequest *)getCopyOfCurrentRequest;

@property (nonatomic, weak) id <TECContentProviderPresentationAdapterProtocol> presentationAdapter;

@end
