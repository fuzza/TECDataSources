//
//  TECCollectionControllerSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/18/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECCollectionViewPresentationAdapter.h"
#import "TECContentProviderProtocol.h"
#import "TECContentProviderDelegate.h"
#import "TECCollectionViewExtender.h"
#import "TECDelegateProxy.h"
#import "TECBlockOperation.h"

SPEC_BEGIN(TECCollectionViewPresentationAdapterSpec)

describe(@"TECCollectionViewPresentationAdapter", ^{
    
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
    
    let(contentProviderMock, ^id{
        id contentProviderMock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        [contentProviderMock stub:@selector(setPresentationAdapter:)];
        return contentProviderMock;
    }) ;
    
    TECCollectionViewPresentationAdapter *(^createSut)() = ^{
        return [[TECCollectionViewPresentationAdapter alloc] initWithContentProvider:contentProviderMock
                                                         collectionView:collectionViewMock
                                                              extenders:@[firstExtender,
                                                                          secondExtender]
                                                          delegateProxy:delegateProxyMock];
    };
    
    context(@"Initialization", ^{
        
        it(@"Should initialize new collection controller", ^{
            TECCollectionViewPresentationAdapter *localSut = createSut();
            [[localSut shouldNot] beNil];
            [[localSut should] beKindOfClass:[TECCollectionViewPresentationAdapter class]];
            [[localSut.extendedView should] equal:collectionViewMock];
        });
        
        it(@"Should be presentation adapter for content provider", ^{
            TECCollectionViewPresentationAdapter *localSut = createSut();
            [[localSut should] conformToProtocol:@protocol(TECContentProviderPresentationAdapterProtocol)];
        });
        
        it(@"Should register controller as presentation adapter for content provider", ^{
            KWCaptureSpy *presentationAdapterSpy = [contentProviderMock captureArgument:@selector(setPresentationAdapter:) atIndex:0];
            TECCollectionViewPresentationAdapter *localSut = createSut();
            [[presentationAdapterSpy.argument should] beIdenticalTo:localSut];
        });
        
        it(@"Should register extenders in delegate proxy", ^{
            [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:firstExtender];
            [[delegateProxyMock should] receive:@selector(attachDelegate:) withArguments:secondExtender];
            __unused TECCollectionViewPresentationAdapter *localSut = createSut();
        });
        
        it(@"Should setup every extender with collection view and content provider", ^{
            [[firstExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
            [[firstExtender should] receive:@selector(setExtendedView:) withArguments:collectionViewMock];
            
            [[secondExtender should] receive:@selector(setContentProvider:) withArguments:contentProviderMock];
            [[secondExtender should] receive:@selector(setExtendedView:) withArguments:collectionViewMock];
            
            __unused TECCollectionViewPresentationAdapter *localSut = createSut();
        });
        
        it(@"Should set delegate proxy as collection view delegate and data source", ^{
            [delegateProxyMock stub:@selector(proxy) andReturn:delegateProxyMock];
            
            [[collectionViewMock should] receive:@selector(setDelegate:) withArguments:delegateProxyMock];
            [[collectionViewMock should] receive:@selector(setDataSource:) withArguments:delegateProxyMock];
            
            __unused TECCollectionViewPresentationAdapter *localSut = createSut();
        });
    });
    
    describe(@"React to content provider changes", ^{
        let(sut, createSut);
        
        let(operationMock, ^id{
            return [TECBlockOperation mock];
        });
        
        let(sectionMock, ^id{
            return [KWMock mockForProtocol:@protocol(TECSectionModelProtocol)];
        });
        
        let(indexPathMock, ^id{
            return [NSIndexPath mock];
        });
        
        let(newIndexPathMock, ^id{
            return [NSIndexPath mock];
        });
        
        typedef void(^TECControllerTestEmptyBlock)();
        
        void(^verifyOperationBlockExecution)(TECControllerTestEmptyBlock) = ^(TECControllerTestEmptyBlock builderBlock) {
            KWCaptureSpy *addOperationSpy = [operationMock captureArgument:@selector(addExecutionBlock:) atIndex:0];
            if(builderBlock) {
                builderBlock();
            }
            void(^operationBlock)() = (void(^)())addOperationSpy.argument;
            operationBlock();
        };
        
        beforeEach(^{
            [TECBlockOperation stub:@selector(operation) andReturn:operationMock];
            [sut contentProviderWillChangeContent:contentProviderMock];
        });
        
        it(@"Should reload collection view when content provider asks", ^{
            [[collectionViewMock should] receive:@selector(reloadData)];
            [sut contentProviderDidReloadData:contentProviderMock];
        });
        
        it(@"Creates new operation before changing content", ^{
            [[TECBlockOperation should] receive:@selector(operation)];
            [sut contentProviderWillChangeContent:contentProviderMock];
        });
        
        it(@"Puts section insert in queue", ^{
            verifyOperationBlockExecution(^{
                [[collectionViewMock should] receive:@selector(insertSections:) withArguments:[NSIndexSet indexSetWithIndex:5]];
                
                [sut contentProviderDidChangeSection:sectionMock atIndex:5 forChangeType:TECContentProviderSectionChangeTypeInsert];
            });
        });
        
        it(@"Puts section delete in queue", ^{
            verifyOperationBlockExecution(^{
                [[collectionViewMock should] receive:@selector(deleteSections:) withArguments:[NSIndexSet indexSetWithIndex:7]];
                [sut contentProviderDidChangeSection:sectionMock atIndex:7 forChangeType:TECContentProviderSectionChangeTypeDelete];
            });
        });
        
        it(@"Puts object insert in queue", ^{
            verifyOperationBlockExecution(^{
                [[collectionViewMock should] receive:@selector(insertItemsAtIndexPaths:) withArguments:@[indexPathMock]];
                [sut contentProviderDidChangeItem:sectionMock atIndexPath:indexPathMock forChangeType:TECContentProviderItemChangeTypeInsert newIndexPath:newIndexPathMock];
            });
        });
        
        it(@"Puts object delete in queue", ^{
            verifyOperationBlockExecution(^{
                [[collectionViewMock should] receive:@selector(deleteItemsAtIndexPaths:) withArguments:@[indexPathMock]];
                [sut contentProviderDidChangeItem:sectionMock atIndexPath:indexPathMock forChangeType:TECContentProviderItemChangeTypeDelete newIndexPath:newIndexPathMock];
            });
        });
        
        it(@"Puts object update in queue", ^{
            verifyOperationBlockExecution(^{
                [[collectionViewMock should] receive:@selector(reloadItemsAtIndexPaths:) withArguments:@[indexPathMock]];
                [sut contentProviderDidChangeItem:sectionMock atIndexPath:indexPathMock forChangeType:TECContentProviderItemChangeTypeUpdate newIndexPath:newIndexPathMock];
            });
        });
        
        it(@"Puts object move in queue", ^{
            verifyOperationBlockExecution(^{
                [[collectionViewMock should] receive:@selector(deleteItemsAtIndexPaths:) withArguments:@[indexPathMock]];
                [[collectionViewMock should] receive:@selector(insertItemsAtIndexPaths:) withArguments:@[newIndexPathMock]];
                [sut contentProviderDidChangeItem:sectionMock atIndexPath:indexPathMock forChangeType:TECContentProviderItemChangeTypeMove newIndexPath:newIndexPathMock];
            });
        });
        
        it(@"Runs batch update after content change", ^{
            KWCaptureSpy *batchUpdateSpy = [collectionViewMock captureArgument:@selector(performBatchUpdates:completion:) atIndex:0];
            [[operationMock should] receive:@selector(start)];
            
            [sut contentProviderDidChangeContent:contentProviderMock];
            
            void(^batchUpdateBlock)() = (void(^)())batchUpdateSpy.argument;
            batchUpdateBlock();
        });
    });
});

SPEC_END
