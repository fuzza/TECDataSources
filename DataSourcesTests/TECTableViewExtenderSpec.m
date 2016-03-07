//
//  TECTableViewExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewExtender.h"

#import "TECContentProviderProtocol.h"

SPEC_BEGIN(TECTableViewExtenderSpec)

describe(@"TECTableViewExtender", ^{
    itBehavesLike(@"table extender", @{@"class" : [TECTableViewExtender class]});
});

SPEC_END
