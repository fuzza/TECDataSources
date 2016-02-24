//
//  TECCollectionViewSupplementaryRegistrationAdapterSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECDummyModels.h"
#import "TECCollectionViewSupplementaryRegistrationAdapter.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECCollectionViewSupplementaryRegistrationAdapterSpec)

describe(@"TECCollectionViewSupplementaryRegistrationAdapter", ^{
    let(collectionViewMock, ^id{
        return [UICollectionView nullMock];
    });
    
    let(typeMock, ^id{
        return [NSString mock];
    });
    
    let(sut, ^TECCollectionViewSupplementaryRegistrationAdapter *{
        return [[TECCollectionViewSupplementaryRegistrationAdapter alloc] initWithCollectionView:collectionViewMock supplementaryType:typeMock];
    });
    
    describe(@"Init", ^{
        it(@"Should return object", ^{
            [[sut shouldNot] beNil];
            [[sut should] beKindOfClass:[TECCollectionViewSupplementaryRegistrationAdapter class]];
            [[sut should] conformToProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Should throw if no supplementary type passed", ^{
            [[theBlock(^{
                __unused id localSut = [[TECCollectionViewSupplementaryRegistrationAdapter alloc] initWithCollectionView:collectionViewMock supplementaryType:nil];
            }) should] raise];
        });
        
        it(@"Should throw if no collection view passed", ^{
            [[theBlock(^{
                __unused id localSut = [[TECCollectionViewSupplementaryRegistrationAdapter alloc] initWithCollectionView:nil supplementaryType:typeMock];
            }) should] raise];
        });
        #endif
    });

    describe(@"View registration", ^{
        let(reuseIdMock, ^NSString *{
            return [NSString mock];
        });
        
        it(@"Should register supplementary view or its subclass for id", ^{
            Class reusableViewClass = [UICollectionReusableView class];
            [[collectionViewMock should] receive:@selector(registerClass:forSupplementaryViewOfKind:withReuseIdentifier:) withArguments:reusableViewClass, typeMock, reuseIdMock];
            [sut registerClass:reusableViewClass forReuseIdentifier:reuseIdMock];
            
            Class reusableViewSubClass = [TECCollectionViewTestSupplementary class];
            [[collectionViewMock should] receive:@selector(registerClass:forSupplementaryViewOfKind:withReuseIdentifier:) withArguments:reusableViewSubClass, typeMock, reuseIdMock];
            [sut registerClass:reusableViewSubClass forReuseIdentifier:reuseIdMock];

        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws if no class passed", ^{
            [[theBlock(^{
                [sut registerClass:nil forReuseIdentifier:reuseIdMock];
            }) should] raise];
        });
        
        it(@"Throws if class is not subclass of UICollectionReusableView", ^{
            Class wrongClass = [UILabel class];
            [[theBlock(^{
                [sut registerClass:wrongClass forReuseIdentifier:reuseIdMock];
            }) should] raise];
        });
        
        it(@"Throws if nor reuse identifier ", ^{
            Class reusableViewClass = [UICollectionReusableView class];
            [[theBlock(^{
                [sut registerClass:reusableViewClass forReuseIdentifier:nil];
            }) should] raise];
        });
        #endif
    });
    
    describe(@"View reusing", ^{
        let(reuseIdMock, ^NSString *{
            return [NSString mock];
        });
        
        let(indexPathMock, ^id{
            return [NSIndexPath mock];
        });
        
        let(viewMock, ^id{
            return [UICollectionReusableView class];
        });
        
        it(@"Returns reused view", ^{
            [[collectionViewMock should] receive:@selector(dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:) andReturn:viewMock withArguments:typeMock, reuseIdMock, indexPathMock];
            id result = [sut reuseViewWithIdentifier:reuseIdMock forIndexPath:indexPathMock];
            [[result should] equal:viewMock];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws if no id passed", ^{
            [[theBlock(^{
                [sut reuseViewWithIdentifier:nil forIndexPath:indexPathMock];
            }) should] raise];
        });
        
        it(@"Throws if no indexPath passed", ^{
            [[theBlock(^{
                [sut reuseViewWithIdentifier:reuseIdMock forIndexPath:nil];
            }) should] raise];
        });
        #endif
    });
});

SPEC_END
