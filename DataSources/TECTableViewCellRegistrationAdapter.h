//
//  TECTableViewCellRegistrationAdapter.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/24/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECTableViewCellRegistrationAdapter : NSObject <TECReusableViewRegistrationAdapterProtocol>

- (instancetype)initWithTableView:(UITableView *)tableView;

- (UITableViewCell *)reuseViewWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
@end
