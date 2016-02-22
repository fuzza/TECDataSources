//
//  TECCollectionViewSimpleFactory.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECReusableViewsFactory.h"

@interface TECCollectionViewSimpleCellFactory <CellType, ModelType>: TECReusableViewsFactory

typedef void(^TECCollectionSimpleFactoryConfiguration)(CellType, ModelType, NSIndexPath *);

@property (nonatomic, strong) TECCollectionSimpleFactoryConfiguration configurationHandler;
- (void)registerCellClass:(Class)aClass;

- (CellType)viewForItem:(ModelType)item atIndexPath:(NSIndexPath *)indexPath;
- (void)configureView:(CellType)view forItem:(ModelType)item atIndexPath:(NSIndexPath *)indexPath;

@end
