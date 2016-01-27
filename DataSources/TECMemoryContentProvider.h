//
//  TECMemoryContentProvider.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECContentProviderProtocol.h"

@interface TECMemoryContentProvider : NSObject <TECContentProviderProtocol>

- (instancetype)initWithSections:(NSArray <id <TECSectionModelProtocol>> *)sections;

@end
