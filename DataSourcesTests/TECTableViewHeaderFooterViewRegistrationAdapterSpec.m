//
//  TECTableViewHeaderFooterViewRegistrationAdapterSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/24/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewHeaderFooterViewRegistrationAdapter.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECTableViewHeaderFooterViewRegistrationAdapterSpec)

describe(@"TECTableViewHeaderFooterViewRegistrationAdapter", ^{
    let(tableViewMock, ^{
        return [UITableView nullMock];
    });
    
    let(sut, ^TECTableViewHeaderFooterViewRegistrationAdapter *{
        return [[TECTableViewHeaderFooterViewRegistrationAdapter alloc] initWithTableView:tableViewMock];
    });
    
    describe(@"Initialization", ^{
        it(@"Returns new adapter", ^{
            [[sut should] beKindOfClass:[TECTableViewHeaderFooterViewRegistrationAdapter class]];
            [[sut should] conformToProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
        });
    });
    
    describe(@"View registration", ^{
        let(reuseIdMock, ^id{
            return [NSString mock];
        });
        
        it(@"Registers view class in table view for provided id", ^{
            Class viewClass = [UITableViewHeaderFooterView class];
            [[tableViewMock should] receive:@selector(registerClass:forHeaderFooterViewReuseIdentifier:) withArguments:viewClass, reuseIdMock];
            
            [sut registerClass:viewClass forReuseIdentifier:reuseIdMock];
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
            return [UITableViewHeaderFooterView mock];
        });
        
        beforeEach(^{
            [tableViewMock stub:@selector(dequeueReusableHeaderFooterViewWithIdentifier:) andReturn:cellMock withArguments:reuseIdMock];
        });
        
        it(@"Returns dequeued view from table view", ^{
            id result = [sut reuseViewWithIdentifier:reuseIdMock forIndexPath:indexPathMock];
            [[result should] beIdenticalTo:cellMock];
        });
        
        it(@"Nil indexPath is ignored", ^{
            [[theBlock(^{
                [sut reuseViewWithIdentifier:reuseIdMock forIndexPath:nil];
            }) shouldNot] raise];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws if reuse id is nil", ^{
            [[theBlock(^{
                [sut reuseViewWithIdentifier:nil forIndexPath:indexPathMock];
            }) should] raise];
        });
        #endif
    });
});

SPEC_END
