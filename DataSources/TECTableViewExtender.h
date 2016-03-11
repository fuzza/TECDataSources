//
//  TECBaseModule.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECExtender.h"

@protocol TECContentProviderProtocol;
@protocol TECTableViewCellFactoryProtocol;

@interface TECTableViewExtender : TECExtender <UITableViewDataSource, UITableViewDelegate>

+ (instancetype)extender;

@property (nonatomic, weak) UITableView *extendedView;

@end
