//
//  TECDelegateProxyTestModels.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TECDelegateProxyEmptyTestModel : NSObject
@end

@interface TECDelegateProxySelectorTestModel : NSObject
- (void)tec_testMethod;
- (NSObject *)tec_testMethodWithReturnedValue;
@end

@protocol TECDelegateProxyTestProtocol <NSObject>
@end

@interface TECDelegateProxyProtocolConformingTestModel : NSObject <TECDelegateProxyTestProtocol>
@end
