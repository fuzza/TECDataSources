//
//  TECTableViewCellRegistrationAdapterSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/24/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewCellRegistrationAdapter.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECTableViewCellRegistrationAdapterSpec)

let(tableViewMock, ^id{
    return [UITableView nullMock];
});

let(sut, ^TECTableViewCellRegistrationAdapter *{
    return [[TECTableViewCellRegistrationAdapter alloc] initWithTableView:tableViewMock];
});

describe(@"Initialization", ^{
    it(@"Returns new adapter", ^{
        [[sut should] beKindOfClass:[TECTableViewCellRegistrationAdapter class]];
        [[sut should] conformToProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
    });
    
    #ifndef DNS_BLOCK_ASSERTIONS
    it(@"Should throw if no table view provided", ^{
        [[theBlock(^{
            __unused id localSut = [[TECTableViewCellRegistrationAdapter alloc] initWithTableView:nil];
        }) should] raise];
    });
    #endif
});

describe(@"View registration", ^{
    let(reuseIdMock, ^id{
        return [NSString mock];
    });
    
    it(@"Registers cell class in table view for provided id", ^{
        Class cellClass = [UITableViewCell class];
        [[tableViewMock should] receive:@selector(registerClass:forCellReuseIdentifier:) withArguments:cellClass, reuseIdMock];
        
        [sut registerClass:cellClass forReuseIdentifier:reuseIdMock];
    });
    
    #ifndef DNS_BLOCK_ASSERTIONS
    it(@"Raises if cell class is not subclass of table view cell or nil", ^{
        [[theBlock(^{
            [sut registerClass:[UIView class] forReuseIdentifier:reuseIdMock];
        }) should] raise];
        
        [[theBlock(^{
            [sut registerClass:nil forReuseIdentifier:reuseIdMock];
        }) should] raise];
    });
    
    it(@"Raises if reuse id is nil", ^{
       [[theBlock(^{
           [sut registerClass:[UITableViewCell class] forReuseIdentifier:nil];
       }) should] raise];
    });
    #endif
});

describe(@"View reusing", ^{
    let(reuseIdMock, ^id {
        return [NSString mock];
    });
    
    let(indexPathMock, ^id{
        return [NSIndexPath mock];
    });
    
    let(cellMock, ^id{
        return [UITableViewCell mock];
    });
    
    beforeEach(^{
        [tableViewMock stub:@selector(dequeueReusableCellWithIdentifier:forIndexPath:) andReturn:cellMock withArguments:reuseIdMock, indexPathMock];
    });
    
    it(@"Returns dequeued cell from table view", ^{
        id result = [sut reuseViewWithIdentifier:reuseIdMock forIndexPath:indexPathMock];
        [[result should] beIdenticalTo:cellMock];
    });
    
    #ifndef DNS_BLOCK_ASSERTIONS
    it(@"Throws if reuse id is nil", ^{
        [[theBlock(^{
            [sut reuseViewWithIdentifier:nil forIndexPath:indexPathMock];
        }) should] raise];
    });
    
    it(@"Throws if indexPath is nil", ^{
        [[theBlock(^{
            [sut reuseViewWithIdentifier:reuseIdMock forIndexPath:nil];
        }) should] raise];
    });
    #endif
});

SPEC_END
