//
//  TECCollectionController.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECPresentationAdapter.h"

@protocol TECContentProviderProtocol;

@class TECCollectionViewExtender;

@interface TECCollectionViewPresentationAdapter : TECPresentationAdapter<UICollectionView *, TECCollectionViewExtender *>

@end
