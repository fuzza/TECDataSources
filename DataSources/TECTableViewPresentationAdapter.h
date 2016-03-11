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

@interface TECTableViewPresentationAdapter : NSObject <TECContentProviderPresentationAdapterProtocol>

@property (nonatomic, strong, readonly) UITableView *extendedView;

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                              tableView:(UITableView *)tableView
                              extenders:(NSArray <TECTableViewExtender *> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy;

@end
