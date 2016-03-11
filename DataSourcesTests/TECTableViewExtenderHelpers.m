//
//  TECTableViewExtenderHelperSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/7/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewExtender.h"

SHARED_EXAMPLES_BEGIN(TECTableViewExtenderHelpers)

sharedExamplesFor(@"table extender", ^(NSDictionary *data) {
    itBehavesLike(@"base extender", data);
    
    __block Class sutClass;
    beforeAll(^{
        sutClass = data[@"class"];
    });
    
    let(sut, ^TECTableViewExtender *{
        return [[sutClass alloc] init];
    });
    
    it(@"Should be an extender", ^{
        [[sut should] beKindOfClass:[TECTableViewExtender class]];
    });
    
    it(@"Should conform table view protocols", ^{
        [[sut should] conformToProtocol:@protocol(UITableViewDataSource)];
        [[sut should] conformToProtocol:@protocol(UITableViewDelegate)];
    });
});

SHARED_EXAMPLES_END
