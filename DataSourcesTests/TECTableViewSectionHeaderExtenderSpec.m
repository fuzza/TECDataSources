//
//  TECTableViewSectionHeaderExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewSectionHeaderExtender.h"
#import "TECContentProviderProtocol.h"

SPEC_BEGIN(TECTableViewSectionHeaderExtenderSpec)

describe(@"TECTableViewSectionHeaderExtender", ^{
    __block TECTableViewSectionHeaderExtender *sut;
    __block id contentProviderMock;
    
    beforeEach(^{
        sut = [[TECTableViewSectionHeaderExtender alloc] init];
        contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
    });
    
    it(@"Should be extender", ^{
        [[sut should] beKindOfClass:[TECTableViewExtender class]];
    });
    
    it(@"Should implement header title delegate method", ^{
        [[sut should] respondToSelector:@selector(tableView:titleForHeaderInSection:)];
    });
    
    it(@"Should return section title from content provider", ^{
        NSInteger sectionIndex = 1;
        NSString *testTitle = @"Test title";
        
        id tableViewMock = [UITableView mock];
        
        id sectionMock = [KWMock mockForProtocol:@protocol(TECSectionModelProtocol)];
        [sectionMock stub:@selector(headerTitle) andReturn:testTitle];
        
        [contentProviderMock stub:@selector(sectionAtIndex:) andReturn:sectionMock withArguments:theValue(sectionIndex)];
        
        [sut tableView:tableViewMock titleForHeaderInSection:sectionIndex];
    });
});

SPEC_END
