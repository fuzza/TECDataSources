//
//  TECCollectionController.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECContentProviderDelegate.h"

@protocol TECContentProviderProtocol;

@class TECCollectionViewExtender;
@class TECDelegateProxy;

@interface TECCollectionViewPresentationAdapter : NSObject <TECContentProviderPresentationAdapterProtocol>

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                         collectionView:(UICollectionView *)collectionView
                              extenders:(NSArray <TECCollectionViewExtender *> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy;

@end
