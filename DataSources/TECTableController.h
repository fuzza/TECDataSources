//
//  TECTableViewDataSource.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECContentProviderProtocol;

@class TECTableViewExtender;

@interface TECTableController : NSObject

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                              tableView:(UITableView *)tableView
                              extenders:(NSArray <TECTableViewExtender *> *)extenders;

@end
