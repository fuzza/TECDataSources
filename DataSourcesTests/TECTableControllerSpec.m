//
//  TECTableControllerSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECTableController.h"
#import "TECContentProviderProtocol.h"
#import "TECDelegateProxy.h"
#import "TECTableViewExtender.h"

SPEC_BEGIN(TECTableControllerSpec)

__block TECTableController *sut;
__block id contentProviderMock;

__block id delegateProxyMock;

describe(@"TECTableController", ^{

    beforeEach(^{
        contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        [contentProviderMock stub:@selector(setPresentationAdapter:)];
        
        delegateProxyMock = [KWMock mockForClass:[TECDelegateProxy class]];
        
        sut = [[TECTableController alloc] initWithContentProvider:contentProviderMock
                                                    delegateProxy:delegateProxyMock];
    });
    
    describe(@"Init", ^{
        it(@"Should be set as presentation adapter for content provider", ^{
            KWCaptureSpy *adapterSpy = [contentProviderMock captureArgument:@selector(setPresentationAdapter:) atIndex:0];
            
            TECTableController *localSut = [[TECTableController alloc] initWithContentProvider:contentProviderMock
                                                                                 delegateProxy:delegateProxyMock];
            [[adapterSpy.argument should] equal:localSut];
        });
    });
    
    describe(@"Table view interactions", ^{
        __block id tableViewMock;
        __block id proxyMock;
        
        beforeEach(^{
            tableViewMock = [UITableView mock];
            [tableViewMock stub:@selector(setDataSource:)];
            [tableViewMock stub:@selector(setDelegate:)];
            
            proxyMock = [KWMock mockForClass:[TECDelegateProxy class]];
            [delegateProxyMock stub:@selector(proxy) andReturn:proxyMock];
            
            [sut setupWithTableView:tableViewMock];
        });
        
        context(@"Setup", ^{
            it(@"Should set delegate proxy as table view delegate and data source", ^{
                KWCaptureSpy *dataSourceSpy = [tableViewMock captureArgument:@selector(setDataSource:) atIndex:0];
                KWCaptureSpy *delegateSpy = [tableViewMock captureArgument:@selector(setDelegate:) atIndex:0];
                
                [sut setupWithTableView:tableViewMock];
                
                [[dataSourceSpy.argument should] beIdenticalTo:proxyMock];
                [[delegateSpy.argument should] beIdenticalTo:proxyMock];
            });
        });
        
        context(@"Dealloc", ^{
            it(@"Should clean table view delegate and datasource", ^{
                [[tableViewMock should] receive:@selector(setDataSource:) withArguments:nil];
                [[tableViewMock should] receive:@selector(setDelegate:) withArguments:nil];
                
                sut = nil;
            });
        });
        
        context(@"Extenders", ^{
            it(@"Should register extenders in delegate proxy", ^{
                id firstExtender = [TECTableViewExtender mock];
                [[firstExtender should] receive:@selector(setTableView:) withArguments:tableViewMock];
                [[firstExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
                
                id secondExtender = [TECTableViewExtender mock];
                [[secondExtender should] receive:@selector(setTableView:) withArguments:tableViewMock];
                [[secondExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
                
                [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:firstExtender];
                [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:secondExtender];
                
                [sut addExtenders:@[firstExtender, secondExtender]];
            });
        });
        
        context(@"Content provider callbacks", ^{
            it(@"Should reload table on reload callback", ^{
                [[tableViewMock should] receive:@selector(reloadData)];
                [sut contentProviderDidReloadData:contentProviderMock];
            });
        });
    });
});

SPEC_END
