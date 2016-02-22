//
//  TECReusableViewsFactoryHelperSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECReusableViewsFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SHARED_EXAMPLES_BEGIN(TECReusableViewsFactoryHelper)

sharedExamplesFor(@"reusable views factory", ^(NSDictionary *data) {
    __block Class sutClass;
    
    beforeAll(^{
        sutClass = data[@"class"];
    });
    
    let(sut, ^TECReusableViewsFactory *{
        return [[sutClass alloc] init];
    });
    
    it(@"Should init with registration adapter", ^{
        id registrationAdapterMock = [KWMock mockForProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
        
        TECReusableViewsFactory *localSut = [[TECReusableViewsFactory alloc] initWithRegistrationAdapter:registrationAdapterMock];
        
        [[localSut shouldNot] beNil];
        [[localSut should] beKindOfClass:[TECReusableViewsFactory class]];
        [[(NSObject *)localSut.registrationAdapter should] equal:registrationAdapterMock];
    });
    
    it(@"Should be an extender", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[TECReusableViewsFactory class]];
    });
    
    it(@"Should implement reusable factory protocol", ^{
        [[sut should] conformToProtocol:@protocol(TECReusableViewFactoryProtocol)];
        
        [[sut should] respondToSelector:@selector(viewForItem:atIndexPath:)];
        [[sut should] respondToSelector:@selector(configureView:forItem:atIndexPath:)];
    });
});

SHARED_EXAMPLES_END
