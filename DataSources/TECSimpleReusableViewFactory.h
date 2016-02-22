//
//  TECCollectionViewSimpleFactory.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECReusableViewsFactory.h"

@interface TECSimpleReusableViewFactory <ViewType, ModelType>: TECReusableViewsFactory

typedef void(^TECSimpleReusableViewFactoryConfigurationHandler)(ViewType, ModelType, NSIndexPath *);

- (void)setConfigurationHandler:(TECSimpleReusableViewFactoryConfigurationHandler)configurationHandler;
- (void)registerViewClass:(Class)aClass;

- (ViewType)viewForItem:(ModelType)item atIndexPath:(NSIndexPath *)indexPath;
- (void)configureView:(ViewType)view forItem:(ModelType)item atIndexPath:(NSIndexPath *)indexPath;

@end
