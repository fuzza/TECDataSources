//
//  TECCollectionViewSupplementaryExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewSupplementaryExtender.h"
#import "TECReusableViewFactoryProtocol.h"
#import "TECContentProviderProtocol.h"

@interface TECCollectionViewSupplementaryExtender ()

@property (nonatomic, strong) id<TECReusableViewFactoryProtocol> headerFactory;
@property (nonatomic, strong) id<TECReusableViewFactoryProtocol> footerFactory;

@end

@implementation TECCollectionViewSupplementaryExtender

- (instancetype)initWithHeaderFactory:(id<TECReusableViewFactoryProtocol>)headerFactory
                        footerFactory:(id<TECReusableViewFactoryProtocol>)footerFactory {
    self = [super init];
    if(self) {
        self.headerFactory = headerFactory;
        self.footerFactory = footerFactory;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id<TECSectionModelProtocol> section = [self.contentProvider sectionAtIndex:indexPath.section];
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return (UICollectionReusableView *)[self.headerFactory viewForItem:section.headerTitle atIndexPath:indexPath];
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return (UICollectionReusableView *)[self.footerFactory viewForItem:section.footerTitle atIndexPath:indexPath];
    }
    
    return nil;
}

@end
