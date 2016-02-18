//
//  TECTableViewSectionFooterExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewSectionFooterExtender.h"
#import "TECContentProviderProtocol.h"

SPEC_BEGIN(TECTableViewSectionFooterExtenderSpec)

describe(@"TECTableViewSectionFooterExtender", ^{
    __block TECTableViewSectionFooterExtender *sut;
    __block id contentProviderMock;
    
    beforeEach(^{
        sut = [[TECTableViewSectionFooterExtender alloc] init];
        contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
    });
    
    it(@"Should be extender", ^{
        [[sut should] beKindOfClass:[TECTableViewExtender class]];
    });
    
    it(@"Should implement header title delegate method", ^{
        [[sut should] respondToSelector:@selector(tableView:titleForFooterInSection:)];
    });
    
    it(@"Should return section title from content provider", ^{
        NSInteger sectionIndex = 1;
        NSString *testTitle = @"Test title";
        
        id tableViewMock = [UITableView mock];
        
        id sectionMock = [KWMock mockForProtocol:@protocol(TECSectionModelProtocol)];
        [sectionMock stub:@selector(footerTitle) andReturn:testTitle];
        
        [contentProviderMock stub:@selector(sectionAtIndex:) andReturn:sectionMock withArguments:theValue(sectionIndex)];
        
        [sut tableView:tableViewMock titleForFooterInSection:sectionIndex];
    });
});

SPEC_END
