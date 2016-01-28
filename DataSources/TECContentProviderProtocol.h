//
//  TECContentProviderProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECSectionModelProtocol.h"

@protocol TECContentProviderPresentationAdapterProtocol;

typedef void(^TECContentProviderCompletionBlock)();

@protocol TECContentProviderProtocol <NSObject>

@property (nonatomic, weak) id <TECContentProviderPresentationAdapterProtocol> presentationAdapter;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)index;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion;

@end
