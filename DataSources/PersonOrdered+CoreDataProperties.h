//
//  PersonOrdered+CoreDataProperties.h
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PersonOrdered.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonOrdered (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSNumber *ordinal;

@end

NS_ASSUME_NONNULL_END
