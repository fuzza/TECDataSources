//
//  DataSourcesTests.m
//  DataSourcesTests
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewCellFactory.h"
#import "TECTableViewCellRegistratorProtocol.h"

SPEC_BEGIN(TECTableViewCellFactorySpec)

__block id cellRegistratorMock;
__block id itemMock;
__block id tableViewMock;
__block id indexPathMock;
__block id cellMock;

beforeEach(^{
    cellRegistratorMock = [KWMock mockForProtocol:@protocol(TECTableViewCellRegistratorProtocol)];
    
    itemMock = [NSObject mock];
    tableViewMock = [UITableView mock];
    indexPathMock = [NSIndexPath mock];
    cellMock = [UITableViewCell mock];
});

describe(@"Creating cell", ^{
    it(@"Should return new or reused cell", ^{
        NSString *testReuseIdentifier = @"testReuseIdentifier";
        
        id itemMock = [NSObject mock];
        id tableViewMock = [UITableView mock];
        id indexPathMock = [NSIndexPath mock];
        id cellMock = [UITableViewCell mock];
        
        [[cellRegistratorMock should] receive:@selector(cellReuseIdentifierForItem:tableView:atIndexPath:)
                                    andReturn:testReuseIdentifier
                                withArguments:itemMock, tableViewMock, indexPathMock];
        
        [[tableViewMock should] receive:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)
                              andReturn:cellMock
                          withArguments:testReuseIdentifier, indexPathMock];
        
        TECTableViewCellFactory *sut = [[TECTableViewCellFactory alloc] initWithСellRegistrator:cellRegistratorMock
                                                  configurationHandler:nil];
        
        UITableViewCell *result = [sut cellForItem:itemMock
                                         tableView:tableViewMock
                                       atIndexPath:indexPathMock];
        
        [[result should] equal:cellMock];
    });
});


describe(@"Configuring cell", ^{
    it(@"Should pass-through cell if no configuration handler", ^{
        TECTableViewCellFactory *sut = [[TECTableViewCellFactory alloc] initWithСellRegistrator:cellRegistratorMock
                                                                           configurationHandler:nil];
        UITableViewCell *result = [sut configureCell:cellMock
                                             forItem:itemMock
                                         inTableView:tableViewMock
                                         atIndexPath:indexPathMock];
        [[result should] equal:cellMock];
    });
    
    it(@"Should return configured cell", ^{
        id configuredCellMock = [UITableViewCell mock];
        
        TECTableViewCellConfigurationHandler handler = ^__kindof UITableViewCell *(UITableViewCell *cell,
                                                                                     id item,
                                                                                     UITableView *tableView,
                                                                                     NSIndexPath *indexPath) {
            [[cell should] equal:cellMock];
            [[item should] equal:itemMock];
            [[tableView should] equal:tableViewMock];
            [[indexPath should] equal:indexPathMock];
            
            return configuredCellMock;
        };
        
        TECTableViewCellFactory *sut = [[TECTableViewCellFactory alloc] initWithСellRegistrator:cellRegistratorMock
                                                                           configurationHandler:handler];
        UITableViewCell *result = [sut configureCell:cellMock
                                                  forItem:itemMock
                                              inTableView:tableViewMock
                                              atIndexPath:indexPathMock];
        
        [[result should] equal:configuredCellMock];
    });
});

SPEC_END