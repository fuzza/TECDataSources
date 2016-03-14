//
//  TECTableViewDataSource.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECPresentationAdapter.h"

@protocol TECContentProviderProtocol;

@class TECTableViewExtender;

@interface TECTableViewPresentationAdapter : TECPresentationAdapter<UITableView *, TECTableViewExtender *>

@end
