//
//  TECCollectionViewSupplementaryRegistrationAdapter.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECCollectionViewSupplementaryRegistrationAdapter : NSObject <TECReusableViewRegistrationAdapterProtocol>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                     supplementaryType:(NSString *)supplementaryType;

- (UICollectionReusableView *)reuseViewWithIdentifier:(NSString *)identifier
                                         forIndexPath:(NSIndexPath *)indexPath;

@end
