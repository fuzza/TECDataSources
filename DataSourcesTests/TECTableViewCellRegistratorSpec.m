//
//  TECTableViewCellRegistratorSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewCellRegistrator.h"

SPEC_BEGIN(TECTableViewCellRegistratorSpec)

__block id itemMock;
__block id tableViewMock;
__block id indexPathMock;

beforeEach(^{
    itemMock = [NSObject mock];
    tableViewMock = [UITableView mock];
    indexPathMock = [NSIndexPath mock];
});

describe(@"Cell reuse identifier", ^{
    it(@"Should register cell once and return proper reuse identifier", ^{
        NSString *testReuseIdentifier = @"testReuseId";
        
        TECTableViewCellClassHandler classHandler = ^Class(id item, NSIndexPath *indexPath) {
            [[item should] equal:itemMock];
            [[indexPath should] equal:indexPathMock];
            return [UITableViewCell class];
        };
        
        TECTableViewCellReuseIdHandler reuseHandler = ^NSString *(Class cellClass, id item, NSIndexPath *indexPath) {
            [[cellClass should] equal:[UITableViewCell class]];
            [[item should] equal:itemMock];
            [[indexPath should] equal:indexPathMock];
            
            return testReuseIdentifier;
        };
        
        TECTableViewCellRegistrator *sut = [[TECTableViewCellRegistrator alloc] initWithClassHandler:classHandler
                                                                                      reuseIdHandler:reuseHandler];
        
        [[tableViewMock should] receive:@selector(registerClass:forCellReuseIdentifier:) withCount:1 arguments:[UITableViewCell class], testReuseIdentifier];
        
        NSString *reuseIdentifier = [sut cellReuseIdentifierForItem:itemMock tableView:tableViewMock atIndexPath:indexPathMock];
        [[reuseIdentifier should] equal:testReuseIdentifier];
        
        NSString *secondIdentifier = [sut cellReuseIdentifierForItem:itemMock tableView:tableViewMock atIndexPath:indexPathMock];
        [[secondIdentifier should] equal:testReuseIdentifier];
    });
});

SPEC_END