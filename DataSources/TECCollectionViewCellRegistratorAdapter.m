//
//  TECCollectionViewCellRegistratorAdapter.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewCellRegistratorAdapter.h"

@interface TECCollectionViewCellRegistratorAdapter ()

@property (nonatomic, weak, readwrite) UICollectionView *collectionView;

@end

@implementation TECCollectionViewCellRegistratorAdapter

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    NSParameterAssert(collectionView);
    self = [super init];
    if(self) {
        self.collectionView = collectionView;
    }
    return self;
}

#pragma mark - TECCellRegistratorAdapterProtocol

- (void)registerClass:(Class)aClass forReuseIdentifier:(NSString *)reuseIdentifier {
    NSAssert([aClass isSubclassOfClass:[UICollectionViewCell class]], @"Class should be UICollectionView subclass");
    [self.collectionView registerClass:aClass forCellWithReuseIdentifier:reuseIdentifier];
}

- (UICollectionViewCell *)reuseViewWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(identifier);
    NSParameterAssert(indexPath);
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                          forIndexPath:indexPath];
}

@end
