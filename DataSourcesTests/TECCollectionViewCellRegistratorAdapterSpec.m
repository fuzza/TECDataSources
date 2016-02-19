//
//  TECCollectionViewCellRegistratorAdapterSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECDummyModels.h"
#import "TECCollectionViewCellRegistratorAdapter.h"

SPEC_BEGIN(TECCollectionViewCellRegistratorAdapterSpec)

describe(@"TECCollectionViewCellRegistratorAdapter", ^{
    let(collectionViewMock, ^id{
        return [UICollectionView mock];
    });
    
    let(sut, ^TECCollectionViewCellRegistratorAdapter *{
        return [[TECCollectionViewCellRegistratorAdapter alloc] initWithCollectionView:collectionViewMock];
    });
    
    describe(@"Initialization", ^{
        it(@"Should return initialized adapter", ^{
            [[sut shouldNot] beNil];
            [[sut should] beKindOfClass:[TECCollectionViewCellRegistratorAdapter class]];
        });
        
        it(@"Should store collection view passed during initialization", ^{
            [[sut.collectionView should] beIdenticalTo:collectionViewMock];
        });
        
        it(@"Shouldn't retain collection view passed during initialization", ^{
            __block TECCollectionViewCellRegistratorAdapter *localSut;
            @autoreleasepool {
                id localCollectionMock = [UICollectionView mock];
                localSut = [[TECCollectionViewCellRegistratorAdapter alloc] initWithCollectionView:localCollectionMock];
                localCollectionMock = nil;
            }
            [[localSut.collectionView should] beNil];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Should assert if no collection view passed during init in debug", ^{
            [[theBlock(^{
                __unused id localSut = [[TECCollectionViewCellRegistratorAdapter alloc] initWithCollectionView:nil];
            }) should] raise];
        });
        #endif
    });
    
    describe(@"Cell class registration", ^{
        __block id testReuseId;
        
        beforeAll(^{
            testReuseId = @"test reuse identifier";
        });
        
        it(@"Should confirm adapter protocol", ^{
            [[sut should] conformToProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
        });
        
        it(@"Should register UICollectionViewCell", ^{
            Class baseCellClass = [UICollectionViewCell class];
            [[collectionViewMock should] receive:@selector(registerClass:forCellWithReuseIdentifier:) withArguments:baseCellClass, testReuseId];
            [sut registerClass:baseCellClass forReuseIdentifier:testReuseId];
        });
        
        it(@"Should register UICollectionViewCell subclass", ^{
            Class childCellClass = [TECCollectionViewTestCell class];
            [[collectionViewMock should] receive:@selector(registerClass:forCellWithReuseIdentifier:) withArguments:childCellClass, testReuseId];
            [sut registerClass:childCellClass forReuseIdentifier:testReuseId];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Should throw if class is not collection view cell", ^{
            [[theBlock(^{
                Class testClass = [NSObject class];
                [sut registerClass:testClass forReuseIdentifier:testReuseId];
            }) should] raise];
        });
        #endif
    });
});

SPEC_END
