//
//  TECCollectionViewCellExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewCellExtender.h"
#import "TECReusableViewFactoryProtocol.h"
#import "TECContentProviderProtocol.h"

@interface TECCollectionViewCellExtender ()

@property (nonatomic, strong) id <TECReusableViewFactoryProtocol> cellFactory;

@end

@implementation TECCollectionViewCellExtender

- (instancetype)initWithCellFactory:(id<TECReusableViewFactoryProtocol>)cellFactory {
    self = [super init];
    if(self) {
        self.cellFactory = cellFactory;
    }
    return self;
}

#pragma mark - UICollectionViewCellDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.contentProvider itemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[self.cellFactory viewForItem:item atIndexPath:indexPath];
    NSParameterAssert([cell isKindOfClass:[UICollectionViewCell class]]);
    
    [self.cellFactory configureView:cell forItem:item atIndexPath:indexPath];
    return cell;
}

@end
