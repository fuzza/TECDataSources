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

typedef void(^TECTableCompletionBlock)();

@interface TECTableController : NSObject

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider;

- (void)setupWithTableView:(UITableView *)tableView;
- (void)reloadDataSourceWithCompletion:(TECTableCompletionBlock)completion;

- (void)addExtenders:(NSArray <TECTableViewExtender *> *)extenders;

@end
