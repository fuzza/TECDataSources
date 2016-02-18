//
//  TECTableViewCellExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewCellExtender.h"
#import "TECTableViewCellFactoryProtocol.h"
#import "TECContentProviderProtocol.h"

SPEC_BEGIN(TECTableViewCellExtenderSpec)

describe(@"TECTableViewCellExtender", ^{
    __block TECTableViewCellExtender *sut;
    __block id cellFactoryMock;
    
    __block id contentProviderMock;
    __block id tableViewMock;
    
    beforeEach(^{
        cellFactoryMock = [KWMock mockForProtocol:@protocol(TECTableViewCellFactoryProtocol)];
        contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        tableViewMock = [UITableView mock];
        
        sut = [[TECTableViewCellExtender alloc] initWithCellFactory:cellFactoryMock];
        sut.contentProvider = contentProviderMock;
        sut.tableView = tableViewMock;
    });
    
    it(@"Should be an extender", ^{
        [[sut should] beKindOfClass:[TECTableViewExtender class]];
    });
    
    it(@"Should return correct number of rows", ^{
        [contentProviderMock stub:@selector(numberOfSections) andReturn:theValue(3)];
        NSInteger result = [sut numberOfSectionsInTableView:tableViewMock];
        [[theValue(result) should] equal:theValue(3)];
    });
    
    it(@"Should return corrent numbers of rows in section", ^{
        [contentProviderMock stub:@selector(numberOfItemsInSection:) andReturn:theValue(25) withArguments:theValue(0)];
        [contentProviderMock stub:@selector(numberOfItemsInSection:) andReturn:theValue(13) withArguments:theValue(1)];
        
        NSInteger zeroSectionRows = [sut tableView:tableViewMock numberOfRowsInSection:0];
        NSInteger firstSectionRows = [sut tableView:tableViewMock numberOfRowsInSection:1];
        
        [[theValue(zeroSectionRows) should] equal:theValue(25)];
        [[theValue(firstSectionRows) should] equal:theValue(13)];
    });
    
    context(@"Cell creation and configuration", ^{
        __block id indexPathMock;
        __block id itemMock;
        __block id cellMock;
        
        beforeEach(^{
            indexPathMock = [NSIndexPath mock];
            itemMock = [NSObject mock];
            cellMock = [UITableViewCell mock];
            
            [contentProviderMock stub:@selector(itemAtIndexPath:) andReturn:itemMock withArguments:indexPathMock];
        });
        
        it(@"Should request cell from factory", ^{
            [cellFactoryMock stub:@selector(cellForItem:tableView:atIndexPath:) andReturn:cellMock withArguments:itemMock, tableViewMock, indexPathMock];
            UITableViewCell *cell = [sut tableView:tableViewMock cellForRowAtIndexPath:indexPathMock];
            [[cell should] beIdenticalTo:cellMock];
        });
        
        it(@"Should configure cell before display", ^{
            [[cellFactoryMock should] receive:@selector(configureCell:forItem:inTableView:atIndexPath:) withArguments:cellMock, itemMock, tableViewMock, indexPathMock];
            [sut tableView:tableViewMock willDisplayCell:cellMock forRowAtIndexPath:indexPathMock];
        });
    });
});

SPEC_END
