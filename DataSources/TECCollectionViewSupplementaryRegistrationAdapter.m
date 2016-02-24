//
//  TECCollectionViewSupplementaryRegistrationAdapter.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewSupplementaryRegistrationAdapter.h"

@interface TECCollectionViewSupplementaryRegistrationAdapter ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *supplementaryType;

@end

@implementation TECCollectionViewSupplementaryRegistrationAdapter

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                     supplementaryType:(NSString *)supplementaryType {
    NSParameterAssert(supplementaryType);
    NSParameterAssert(collectionView);
    self = [super init];
    if(self) {
        self.supplementaryType = supplementaryType;
        self.collectionView = collectionView;
    }
    return self;
}

- (void)registerClass:(Class)aClass forReuseIdentifier:(NSString *)reuseIdentifier {
    NSParameterAssert([aClass isSubclassOfClass:[UICollectionReusableView class]]);
    NSParameterAssert(reuseIdentifier);
    [self.collectionView registerClass:aClass forSupplementaryViewOfKind:self.supplementaryType withReuseIdentifier:reuseIdentifier];
}

- (UIView *)reuseViewWithIdentifier:(NSString *)identifier
                       forIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(identifier);
    NSParameterAssert(indexPath);
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:self.supplementaryType withReuseIdentifier:identifier forIndexPath:indexPath];
}

@end
