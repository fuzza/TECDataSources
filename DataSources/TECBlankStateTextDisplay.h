//
//  TECBlankStateTextDisplay.h
//  DataSources
//
//  Created by Petro Korienev on 3/16/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECBlankStateDecorator.h"

@interface TECBlankStateTextDisplay : NSObject <TECBlankStateDisplayProtocol>

- (instancetype)initWithText:(NSString *)text;

@end
