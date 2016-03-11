//
//  TECExtenderHelpersSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/7/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECExtender.h"
#import "TECContentProviderProtocol.h"

SHARED_EXAMPLES_BEGIN(TECExtenderHelpersSpec)

sharedExamplesFor(@"base extender", ^(NSDictionary *data) {
    __block Class sutClass;
    
    beforeAll(^{
        sutClass = data[@"class"];
    });
    
    let(sut, ^TECExtender *{
        return [[sutClass alloc] init];
    });
    
    it(@"Should be an extender", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[TECExtender class]];
        [[sut should] conformToProtocol:@protocol(UIScrollViewDelegate)];
    });

    it(@"Should have weak property to content provider", ^{
        @autoreleasepool {
            id providerMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
            sut.contentProvider = providerMock;
            providerMock = nil;
        }
        [[(KWMock *)sut.contentProvider should] beNil];
    });
    
    it(@"Should have weak link to extended view", ^{
        @autoreleasepool {
            id scrollViewMock = [UIScrollView mock];
            sut.extendedView = scrollViewMock;
            scrollViewMock = nil;
        }
        [[sut.extendedView should] beNil];
    });
});

SHARED_EXAMPLES_END
