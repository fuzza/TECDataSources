//
//  TECExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/7/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECExtender.h"

SPEC_BEGIN(TECExtenderSpec)

describe(@"TECExtender", ^{
    itBehavesLike(@"base extender", @{@"class" : [TECExtender class]});
});

SPEC_END
