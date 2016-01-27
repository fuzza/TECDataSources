//
//  TECTableViewDelegateProxy.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TECDelegateProxy <T>: NSProxy

- (instancetype)initWithPrimaryDelegate:(T)delegate;
- (T)proxy;

- (void)attachSecondaryDelegate:(T)delegate;
- (void)deattachSecondaryDelegate:(T)delegate;

@end
