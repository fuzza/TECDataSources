//
//  TECTableViewCellExtender.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewExtender.h"

@protocol TECReusableViewFactoryProtocol;

TECTableViewExtenderInterface(TECTableViewCellExtender)

+ (instancetype)cellExtenderWithCellFactory:(id <TECReusableViewFactoryProtocol>)cellFactory;
- (instancetype)initWithCellFactory:(id <TECReusableViewFactoryProtocol>)cellFactory;

TECTableViewExtenderEnd
