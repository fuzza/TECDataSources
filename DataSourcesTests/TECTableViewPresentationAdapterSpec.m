//
//  TECTableControllerSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableViewPresentationAdapter.h"
#import "TECContentProviderProtocol.h"
#import "TECDelegateProxy.h"
#import "TECTableViewExtender.h"

SPEC_BEGIN(TECTableViewPresentationAdapterSpec)

__block TECTableViewPresentationAdapter *sut;
__block id contentProviderMock;

__block id delegateProxyMock;

__block id firstExtender;
__block id secondExtender;

__block id tableViewMock;

describe(@"TECTableViewPresentationAdapter", ^{

    beforeEach(^{
        contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        [contentProviderMock stub:@selector(setPresentationAdapter:)];
        
        delegateProxyMock = [KWMock nullMockForClass:[TECDelegateProxy class]];
        
        firstExtender = [TECTableViewExtender nullMock];
        secondExtender = [TECTableViewExtender nullMock];
        
        tableViewMock = [UITableView mock];
        [tableViewMock stub:@selector(setDataSource:)];
        [tableViewMock stub:@selector(setDelegate:)];
    });
    
    describe(@"Init", ^{
        it(@"Should be set as presentation adapter for content provider", ^{
            KWCaptureSpy *adapterSpy = [contentProviderMock captureArgument:@selector(setPresentationAdapter:) atIndex:0];
            
            sut = [[TECTableViewPresentationAdapter alloc] initWithContentProvider:contentProviderMock
                                                            tableView:tableViewMock
                                                            extenders:@[firstExtender, secondExtender]
                                                        delegateProxy:delegateProxyMock];
            [[adapterSpy.argument should] equal:sut];
            [[sut.extendedView should] equal:tableViewMock];
        });
    });
    
    describe(@"Table view interactions", ^{
        __block id proxyMock;
        
        beforeEach(^{
            proxyMock = [KWMock mockForClass:[TECDelegateProxy class]];
            [delegateProxyMock stub:@selector(proxy) andReturn:proxyMock];
        });
        
        context(@"Setup", ^{
            it(@"Should set delegate proxy as table view delegate and data source", ^{
                KWCaptureSpy *dataSourceSpy = [tableViewMock captureArgument:@selector(setDataSource:) atIndex:0];
                KWCaptureSpy *delegateSpy = [tableViewMock captureArgument:@selector(setDelegate:) atIndex:0];
                
                sut = [[TECTableViewPresentationAdapter alloc] initWithContentProvider:contentProviderMock
                                                                tableView:tableViewMock
                                                                extenders:@[firstExtender, secondExtender]
                                                            delegateProxy:delegateProxyMock];
                
                [[dataSourceSpy.argument should] beIdenticalTo:proxyMock];
                [[delegateSpy.argument should] beIdenticalTo:proxyMock];
            });
        });
        
        context(@"Dealloc", ^{
            it(@"Should clean table view delegate and datasource", ^{
                sut = [[TECTableViewPresentationAdapter alloc] initWithContentProvider:contentProviderMock
                                                                tableView:tableViewMock
                                                                extenders:@[firstExtender, secondExtender]
                                                            delegateProxy:delegateProxyMock];
                
                [[tableViewMock should] receive:@selector(setDataSource:) withArguments:nil];
                [[tableViewMock should] receive:@selector(setDelegate:) withArguments:nil];
                
                sut = nil;
            });
        });
        
        context(@"Extenders", ^{
            it(@"Should register extenders in delegate proxy", ^{
                [[firstExtender should] receive:@selector(setExtendedView:) withArguments:tableViewMock];
                [[firstExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
                [[secondExtender should] receive:@selector(setExtendedView:) withArguments:tableViewMock];
                [[secondExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
                [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:firstExtender];
                [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:secondExtender];
                
                sut = [[TECTableViewPresentationAdapter alloc] initWithContentProvider:contentProviderMock
                                                                tableView:tableViewMock
                                                                extenders:@[firstExtender, secondExtender]
                                                            delegateProxy:delegateProxyMock];
            });
        });
        
        context(@"Content provider callbacks", ^{
            it(@"Should reload table on reload callback", ^{
                sut = [[TECTableViewPresentationAdapter alloc] initWithContentProvider:contentProviderMock
                                                                tableView:tableViewMock
                                                                extenders:@[firstExtender, secondExtender]
                                                            delegateProxy:delegateProxyMock];
                [[tableViewMock should] receive:@selector(reloadData)];
                [sut contentProviderDidReloadData:contentProviderMock];
            });
        });
    });
});

SPEC_END
