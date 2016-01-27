//
//  TECSectionModel.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECSectionModelProtocol <NSObject>

@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) NSString *headerTitle;
@property (nonatomic, strong, readonly) NSString *footerTitle;

@end
