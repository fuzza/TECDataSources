//
//  TECTableViewDelegateProxy.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TECDelegateProxy <T>: NSProxy

- (instancetype)init;
- (T)proxy;

- (void)attachDelegate:(T)delegate;
- (void)detachDelegate:(T)delegate;

@end
