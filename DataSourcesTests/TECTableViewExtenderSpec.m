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
    __block TECTableViewExtender *sut;
    
    beforeEach(^{
        sut = [[TECTableViewExtender alloc] init];
    });
    
    it(@"Should create new extender", ^{
        [[sut shouldNot] beNil];
    });
    
    it(@"Should be table view data source", ^{
        [[sut should] conformToProtocol:@protocol(UITableViewDataSource)];
    });
    
    it(@"Should be table view delegate", ^{
        [[sut should] conformToProtocol:@protocol(UITableViewDelegate)];
    });
    
    it(@"Should store content provider", ^{
        id contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        sut.contentProvider = contentProviderMock;
        [[(NSObject *)sut.contentProvider should] beIdenticalTo:contentProviderMock];
    });
    
    it(@"Should store table view", ^{
        id tableViewMock = [UITableView mock];
        sut.tableView = tableViewMock;
        [[sut.tableView should] beIdenticalTo:tableViewMock];
    });
});

SPEC_END
