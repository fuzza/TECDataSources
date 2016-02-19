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
    NSParameterAssert([aClass isSubclassOfClass:[UICollectionViewCell class]]);
    [self.collectionView registerClass:aClass forCellWithReuseIdentifier:reuseIdentifier];
}

@end
