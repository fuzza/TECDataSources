//
//  TECCollectionViewSimpleFactorySpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECDummyModels.h"
#import "TECCollectionViewSimpleCellFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECCollectionViewSimpleCellFactorySpec)

describe(@"TECCollectionViewSimpleFactory", ^{
    itBehavesLike(@"reusable views factory", @{@"class" : [TECCollectionViewSimpleCellFactory class]});
    
    let(cellMock, ^id{
        return [TECCollectionViewTestCell new];
    });
    
    let(cellClass, ^Class{
        return [UICollectionViewCell class];
    });
    
    let(cellSubclass, ^Class{
        return [TECCollectionViewTestCell class];
    });
    
    let(adapterMock, ^id{
        return [KWMock nullMockForProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
    });
    
    let(sut, ^TECCollectionViewSimpleCellFactory <TECCollectionViewTestCell *, NSString *> *{
        return [[TECCollectionViewSimpleCellFactory alloc] initWithRegistrationAdapter:adapterMock];
    });
    
    let(indexPathMock, ^id{
        return [NSIndexPath mock];
    });
    
    describe(@"Cell class registration", ^{
        it(@"Register cell or subclass in adapter by class name", ^{
            [[adapterMock should] receive:@selector(registerClass:forReuseIdentifier:)
                            withArguments: cellClass, NSStringFromClass(cellClass)];
            [sut registerCellClass:cellClass];
        });
        
        it(@"Register cell subclass in adapter by class name", ^{
            [[adapterMock should] receive:@selector(registerClass:forReuseIdentifier:)
                            withArguments: cellSubclass, NSStringFromClass(cellSubclass)];
            [sut registerCellClass:cellSubclass];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws on second register", ^{
            [sut registerCellClass:cellClass];
            [[theBlock(^{
                [sut registerCellClass:cellSubclass];
            }) should] raise];
        });
        
        it(@"Throws if no class passed", ^{
            [[theBlock(^{
                [sut registerCellClass:nil];
            }) should] raise];
        });
        
        it(@"Throws if class is not cell class", ^{
            [[theBlock(^{
                [sut registerCellClass:[UIImage class]];
            }) should] raise];
        });
        #endif
    });
    
    describe(@"Cell creation", ^{
        let(cellSubclass, ^Class{
            return [TECCollectionViewTestCell class];
        });
        
        it(@"Return reused cell from adapter", ^{
            [sut registerCellClass:cellSubclass];
            [adapterMock stub:@selector(reuseViewWithIdentifier:forIndexPath:) andReturn:cellMock withArguments:NSStringFromClass(cellSubclass), indexPathMock];
            id result = [sut viewForItem:@"test item" atIndexPath:indexPathMock];
            [[result should] equal:cellMock];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Throws if reused object is not cell", ^{
            [sut registerCellClass:cellSubclass];
            [adapterMock stub:@selector(reuseViewWithIdentifier:forIndexPath:) andReturn:[NSLayoutAnchor new] withArguments:NSStringFromClass(cellSubclass), indexPathMock];
            [[theBlock(^{
                __unused id result = [sut viewForItem:@"test item" atIndexPath:indexPathMock];
            }) should] raise];
        });
        

        it(@"Throws if cell is not registered", ^{
            [adapterMock stub:@selector(reuseViewWithIdentifier:forIndexPath:) andReturn:cellMock];
            [[theBlock(^{
                __unused id result = [sut viewForItem:@"test item" atIndexPath:indexPathMock];
            }) should] raise];
        });
        #endif
    });
    
    describe(@"Cell configuration", ^{
        it(@"Calls config block with params", ^{
            __block BOOL blockRunned = NO;
            [sut setConfigurationHandler:^(TECCollectionViewTestCell *cell, NSString *item, NSIndexPath *path) {
                [[cell should] equal:cellMock];
                [[item should] equal:@"test"];
                [[path should] equal:indexPathMock];
                blockRunned = YES;
            }];
            
            [sut configureView:cellMock forItem:@"test" atIndexPath:indexPathMock];
            [[theValue(blockRunned) should] beTrue];
        });
        
        it(@"Shouldn't crash if no block", ^{
            [sut configureView:cellMock forItem:@"test" atIndexPath:indexPathMock];
        });
    });
    
});

SPEC_END
