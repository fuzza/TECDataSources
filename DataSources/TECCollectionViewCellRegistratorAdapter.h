//
//  TECCollectionViewCellRegistratorAdapter.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECCollectionViewCellRegistratorAdapter : NSObject <TECReusableViewRegistrationAdapterProtocol>

@property (nonatomic, weak, readonly) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
- (UICollectionViewCell *)reuseViewWithIdentifier:(NSString *)identifier
                                     forIndexPath:(NSIndexPath *)indexPath;

@end
