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

sharedExamplesFor(@"collection extender", ^(NSDictionary *data) {
    itBehavesLike(@"base extender", data);
    
    __block Class sutClass;
    beforeAll(^{
        sutClass = data[@"class"];
    });
    
    let(sut, ^TECCollectionViewExtender *{
        return [[sutClass alloc] init];
    });
    
    it(@"Should be a collection extender", ^{
        [[sut should] beKindOfClass:[TECCollectionViewExtender class]];
    });
    
    it(@"Should conform collection view protocols", ^{
        [[sut should] conformToProtocol:@protocol(UICollectionViewDataSource)];
        [[sut should] conformToProtocol:@protocol(UICollectionViewDelegate)];
    });
});

SHARED_EXAMPLES_END
