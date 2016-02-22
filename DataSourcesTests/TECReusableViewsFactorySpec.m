//
//  TECReusableViewsFactorySpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECReusableViewsFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECReusableViewsFactorySpec)

describe(@"TECReusableViewsFactory", ^{
    itBehavesLike(@"reusable views factory", @{@"class" : [TECReusableViewsFactory class]});
    
    let(adapterMock, ^id{
        return [KWMock mockForProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
    });
    
    let(sut, ^id{
        return [[TECReusableViewsFactory alloc] initWithRegistrationAdapter:adapterMock];
    });
    
    describe(@"Factory implementation", ^{
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Should be overriden in child classes", ^{
            id itemMock = [NSObject new];
            id indexPathMock = [NSIndexPath new];
            id viewMock = [UIView mock];

            [[theBlock(^{
                [sut viewForItem:itemMock atIndexPath:indexPathMock];
            }) should] raise];
            
            [[theBlock(^{
                [sut configureView:viewMock forItem:itemMock atIndexPath:indexPathMock];
            }) should] raise];
        });
        #endif
    });
});

SPEC_END
