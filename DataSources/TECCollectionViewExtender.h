//
//  TECCollectionViewExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECExtender.h"

@interface TECCollectionViewExtender : TECExtender <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *extendedView;

@end
