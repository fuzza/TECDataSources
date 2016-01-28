//
//  TECTableViewCellExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewExtender.h"

@protocol TECTableViewCellFactoryProtocol;

@interface TECTableViewCellExtender : TECTableViewExtender

- (instancetype)initWithCellFactory:(id <TECTableViewCellFactoryProtocol>)cellFactory;

@end
