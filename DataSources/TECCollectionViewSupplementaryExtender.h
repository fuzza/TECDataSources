//
//  TECCollectionViewSupplementaryExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewExtender.h"

@protocol TECReusableViewFactoryProtocol;

@interface TECCollectionViewSupplementaryExtender : TECCollectionViewExtender

- (instancetype)initWithHeaderFactory:(id <TECReusableViewFactoryProtocol>)headerFactory
                        footerFactory:(id <TECReusableViewFactoryProtocol>)footerFactory;

@end
