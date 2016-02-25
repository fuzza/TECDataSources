//
//  TECCollectionViewExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECCollectionViewExtender.h"

SPEC_BEGIN(TECCollectionViewExtenderSpec)

describe(@"TECCollectionViewExtender", ^{
    itBehavesLike(@"extender", @{@"class" : [TECCollectionViewExtender class]});
});

SPEC_END
