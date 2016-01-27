//
//  TECBaseModule.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECContentProviderProtocol;
@protocol TECTableViewCellFactoryProtocol;

@interface TECTableViewExtender : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TECContentProviderProtocol> contentProvider;
@property (nonatomic, weak) id<TECTableViewCellFactoryProtocol> cellFactory;
@property (nonatomic, weak) UITableView *tableView;

@end
