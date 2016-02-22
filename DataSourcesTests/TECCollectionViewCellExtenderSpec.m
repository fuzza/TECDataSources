//
//  TECCollectionViewCellExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECCollectionViewCellExtender.h"
#import "TECReusableViewFactoryProtocol.h"
#import "TECContentProviderProtocol.h"

SPEC_BEGIN(TECCollectionViewCellExtenderSpec)

describe(@"TECCollectionViewCellExtender", ^{
    itBehavesLike(@"extender", @{@"class" : [TECCollectionViewCellExtender class]});
    
    let(cellFactoryMock, ^id{
        return [KWMock nullMockForProtocol:@protocol(TECReusableViewFactoryProtocol)];
    });
    
    let(contentProviderMock, ^id{
        return [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
    });
    
    let(collectionViewMock, ^id{
        return [UICollectionView mock];
    });
    
    let(sut, ^TECCollectionViewCellExtender *{
        return [[TECCollectionViewCellExtender alloc] initWithCellFactory:cellFactoryMock];
    });
    
    describe(@"Initialization", ^{
        it(@"Should initialize object", ^{
            [[sut shouldNot] beNil];
            [[sut should] beKindOfClass:[TECCollectionViewCellExtender class]];
        });
    });
    
    describe(@"Cell instantiation", ^{
        let(itemMock, ^id{
            return [NSString mock];
        });
        
        let(indexPathMock, ^id{
            return [NSIndexPath mock];
        });
        
        beforeEach(^{
            sut.contentProvider = contentProviderMock;
            sut.collectionView = collectionViewMock;
            [contentProviderMock stub:@selector(itemAtIndexPath:) andReturn:itemMock withArguments:indexPathMock];
        });
        
        it(@"Should return cell from factory and configure it", ^{
            id cellMock = [UICollectionViewCell new];
            [cellFactoryMock stub:@selector(viewForItem:atIndexPath:) andReturn:cellMock withArguments:itemMock, indexPathMock];
            [[cellFactoryMock should] receive:@selector(configureView:forItem:atIndexPath:) withArguments:cellMock, itemMock, indexPathMock];
            
            id result = [sut collectionView:collectionViewMock cellForItemAtIndexPath:indexPathMock];
            [[result should] beIdenticalTo:cellMock];
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        it(@"Should raise if factory didn't return cell subclass", ^{
            id cellMock = [UITableViewCell new];
            [cellFactoryMock stub:@selector(viewForItem:atIndexPath:) andReturn:cellMock withArguments:itemMock, indexPathMock];
            [[theBlock(^{
                [sut collectionView:collectionViewMock cellForItemAtIndexPath:indexPathMock];
            }) should] raise];
        });
        #endif
    });
});

SPEC_END
