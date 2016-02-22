//
//  TECCellRegistratorAdapterProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECReusableViewRegistrationAdapterProtocol <NSObject>

- (void)registerClass:(Class)aClass forReuseIdentifier:(NSString *)reuseIdentifier;
- (UIView *)reuseViewWithIdentifier:(NSString *)identifier
                       forIndexPath:(NSIndexPath *)indexPath;

@end
