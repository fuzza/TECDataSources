//
//  TECCollectionExtenderHelpers.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECCollectionViewExtender.h"
#import "TECContentProviderProtocol.h"

SHARED_EXAMPLES_BEGIN(TECCollectionViewExtenderHelpers)

sharedExamplesFor(@"extender", ^(NSDictionary *data) {
    __block Class sutClass;
    
    beforeAll(^{
        sutClass = data[@"class"];
    });
    
    let(sut, ^TECCollectionViewExtender *{
        return [[sutClass alloc] init];
    });
    
    it(@"Should be an extender", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[TECCollectionViewExtender class]];
    });
    
    it(@"Should be collection view data source", ^{
        [[sut should] conformToProtocol:@protocol(UICollectionViewDataSource)];
    });
    
    it(@"Should be collection view delegate", ^{
        [[sut should] conformToProtocol:@protocol(UICollectionViewDelegate)];
    });
    
    it(@"Should have weak property to content provider", ^{
        @autoreleasepool {
            id providerMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
            sut.contentProvider = providerMock;
            providerMock = nil;
        }
        [[(KWMock *)sut.contentProvider should] beNil];
    });
    
    it(@"Should have weak link to collection view", ^{
        @autoreleasepool {
            id collectionViewMock = [UICollectionView mock];
            sut.collectionView = collectionViewMock;
            collectionViewMock = nil;
        }
        [[sut.collectionView should] beNil];
    });
});

SHARED_EXAMPLES_END
