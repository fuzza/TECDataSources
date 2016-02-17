//
//  TECDelegateProxyTestModels.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECDelegateProxyTestModels.h"

@implementation TECDelegateProxyEmptyTestModel
@end

@implementation TECDelegateProxySelectorTestModel
- (void)tec_testMethod {}
- (NSObject *)tec_testMethodWithReturnedValue {return [NSObject new];}
@end

@implementation TECDelegateProxyProtocolConformingTestModel
@end
