//
//  TECCollectionViewCellExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewExtender.h"

@protocol TECReusableViewFactoryProtocol;

@interface TECCollectionViewCellExtender : TECCollectionViewExtender

- (instancetype)initWithCellFactory:(id<TECReusableViewFactoryProtocol>)cellFactory;

@end
