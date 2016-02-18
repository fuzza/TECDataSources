//
//  TECTableViewDataSource.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECContentProviderDelegate.h"

@protocol TECContentProviderProtocol;

@class TECTableViewExtender;
@class TECDelegateProxy;

@interface TECTableController : NSObject <TECContentProviderPresentationAdapterProtocol>

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                          delegateProxy:(TECDelegateProxy *)delegateProxy;

- (void)setupWithTableView:(UITableView *)tableView;

- (void)addExtenders:(NSArray <TECTableViewExtender *> *)extenders;

@end
