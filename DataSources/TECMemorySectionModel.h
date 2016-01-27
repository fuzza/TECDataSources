//
//  TECMemorySectionModel.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECSectionModelProtocol.h"

@interface TECMemorySectionModel <T> : NSObject <TECSectionModelProtocol>

#pragma mark - Initializers

- (instancetype)initWithItems:(NSArray <T> *)items;

- (instancetype)initWithItems:(NSArray <T> *)items
                  headerTitle:(NSString *)headerTitle
                  footerTitle:(NSString *)footerTitle;

#pragma mark - Objects casting

@property (nonatomic, strong, readonly) NSArray <T> *items;
- (void)replaceItems:(NSArray <T> *)items;

@end
