//
//  TECCollectionViewSimpleFactorySpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECDummyModels.h"
#import "TECSimpleReusableViewFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECCollectionViewSimpleCellFactorySpec)

describe(@"TECSimpleReusableViewFactory", ^{
    itBehavesLike(@"reusable views factory", @{@"class" : [TECSimpleReusableViewFactory class]});
    
    let(viewMock, ^id{
        return [UICollectionViewCell new];
    });
    
    let(viewClass, ^Class{
        return [UICollectionViewCell class];
    });
    
    let(adapterMock, ^id{
        return [KWMock nullMockForProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
    });
    
    let(sut, ^TECSimpleReusableViewFactory <UICollectionViewCell *, NSString *> *{
        return [[TECSimpleReusableViewFactory alloc] initWithRegistrationAdapter:adapterMock];
    });
    
    let(indexPathMock, ^id{
        return [NSIndexPath mock];
    });
    
    describe(@"View class registration", ^{
        it(@"Register view in adapter by class name", ^{
            [[adapterMock should] receive:@selector(registerClass:forReuseIdentifier:)
                            withArguments:viewClass, NSStringFromClass(viewClass)];
            [sut registerViewClass:viewClass];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws on second register", ^{
            [sut registerViewClass:viewClass];
            [[theBlock(^{
                [sut registerViewClass:[UILabel class]];
            }) should] raise];
        });
        
        it(@"Throws if no class passed", ^{
            [[theBlock(^{
                [sut registerViewClass:nil];
            }) should] raise];
        });
        #endif
    });
    
    describe(@"View creation", ^{
        it(@"Return reused view from adapter", ^{
            [sut registerViewClass:viewClass];
            [adapterMock stub:@selector(reuseViewWithIdentifier:forIndexPath:) andReturn:viewMock withArguments:NSStringFromClass(viewClass), indexPathMock];
            id result = [sut viewForItem:@"test item" atIndexPath:indexPathMock];
            [[result should] equal:viewMock];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws if object class is not strictly matched to registered", ^{
            [sut registerViewClass:viewClass];
            [adapterMock stub:@selector(reuseViewWithIdentifier:forIndexPath:) andReturn:[UILabel new] withArguments:NSStringFromClass(viewClass), indexPathMock];
            [[theBlock(^{
                __unused id result = [sut viewForItem:@"test item" atIndexPath:indexPathMock];
            }) should] raise];
        });
        

        it(@"Throws if view is not registered", ^{
            [adapterMock stub:@selector(reuseViewWithIdentifier:forIndexPath:) andReturn:viewMock];
            [[theBlock(^{
                __unused id result = [sut viewForItem:@"test item" atIndexPath:indexPathMock];
            }) should] raise];
        });
        #endif
    });
    
    describe(@"Cell configuration", ^{
        it(@"Calls config block with params", ^{
            __block BOOL blockRunned = NO;
            [sut setConfigurationHandler:^(UICollectionViewCell *cell, NSString *item, NSIndexPath *path) {
                [[cell should] equal:viewMock];
                [[item should] equal:@"test"];
                [[path should] equal:indexPathMock];
                blockRunned = YES;
            }];
            
            [sut configureView:viewMock forItem:@"test" atIndexPath:indexPathMock];
            [[theValue(blockRunned) should] beTrue];
        });
        
        it(@"Shouldn't crash if no block", ^{
            [sut configureView:viewMock forItem:@"test" atIndexPath:indexPathMock];
        });
    });
    
});

SPEC_END
