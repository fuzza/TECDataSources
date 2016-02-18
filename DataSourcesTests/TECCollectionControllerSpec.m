//
//  TECCollectionControllerSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECCollectionController.h"
#import "TECContentProviderProtocol.h"
#import "TECContentProviderDelegate.h"
#import "TECCollectionViewExtender.h"
#import "TECDelegateProxy.h"

SPEC_BEGIN(TECCollectionControllerSpec)

describe(@"TECCollectionController", ^{
    
    let(delegateProxyMock, ^id {
        return [KWMock nullMockForClass:[TECDelegateProxy class]];
    });
    
    let(firstExtender, ^TECCollectionViewExtender *{
        return [TECCollectionViewExtender nullMock];
    });
    
    let(secondExtender, ^TECCollectionViewExtender *{
        return [TECCollectionViewExtender nullMock];
    });
    
    let(collectionViewMock, ^UICollectionView *{
        return [UICollectionView nullMock];
    });
    
    __block id contentProviderMock;

    beforeEach(^{
        contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        [contentProviderMock stub:@selector(setPresentationAdapter:)];
    });
    
    TECCollectionController *(^createSut)() = ^{
        return [[TECCollectionController alloc] initWithContentProvider:contentProviderMock
                                                         collectionView:collectionViewMock
                                                              extenders:@[firstExtender,
                                                                          secondExtender]
                                                          delegateProxy:delegateProxyMock];
    };
    
    context(@"Initialization", ^{
        
        it(@"Should initialize new collection controller", ^{
            TECCollectionController *localSut = createSut();
            [[localSut shouldNot] beNil];
            [[localSut should] beKindOfClass:[TECCollectionController class]];
        });
        
        it(@"Should be presentation adapter for content provider", ^{
            TECCollectionController *localSut = createSut();
            [[localSut should] conformToProtocol:@protocol(TECContentProviderPresentationAdapterProtocol)];
        });
        
        it(@"Should register controller as presentation adapter for content provider", ^{
            KWCaptureSpy *presentationAdapterSpy = [contentProviderMock captureArgument:@selector(setPresentationAdapter:) atIndex:0];
            TECCollectionController *localSut = createSut();
            [[presentationAdapterSpy.argument should] beIdenticalTo:localSut];
        });
        
        it(@"Should register extenders in delegate proxy", ^{
            [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:firstExtender];
            [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:secondExtender];
            __unused TECCollectionController *localSut = createSut();
        });
        
        it(@"Should setup every extender with collection view and content provider", ^{
            [[firstExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
            [[firstExtender should] receive:@selector(setCollectionView:) withArguments:collectionViewMock];
            
            [[secondExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
            [[secondExtender should] receive:@selector(setCollectionView:) withArguments:collectionViewMock];
            
            __unused TECCollectionController *localSut = createSut();
        });
        
        it(@"Should set delegate proxy as collection view delegate and data source", ^{
            [delegateProxyMock stub:@selector(proxy) andReturn:delegateProxyMock];
            
            [[collectionViewMock should] receive:@selector(setDelegate:) withArguments:delegateProxyMock];
            [[collectionViewMock should] receive:@selector(setDataSource:) withArguments:delegateProxyMock];
            
            __unused TECCollectionController *localSut = createSut();
        });
    });
    
    describe(@"React to content provider changes", ^{
        let(sut, createSut);
        
        it(@"Should reload collection view when content provider asks", ^{
            [[collectionViewMock should] receive:@selector(reloadData)];
            [sut contentProviderDidReloadData:contentProviderMock];
        });
    });
});

SPEC_END
