//
//  TECCollectionViewSupplementaryExtenderSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECCollectionViewSupplementaryExtender.h"
#import "TECReusableViewFactoryProtocol.h"
#import "TECContentProviderProtocol.h"

SPEC_BEGIN(TECCollectionViewSupplementaryExtenderSpec)

describe(@"TECCollectionViewSupplementaryExtender", ^{
    itBehavesLike(@"collection extender", @{@"class" : [TECCollectionViewSupplementaryExtender class]});
});

let(headerFactoryMock,^id{
    return [KWMock mockForProtocol:@protocol(TECReusableViewFactoryProtocol)];
});

let(footerFactoryMock, ^id{
    return [KWMock mockForProtocol:@protocol(TECReusableViewFactoryProtocol)];
});

let(sut, ^TECCollectionViewSupplementaryExtender *{
    return [[TECCollectionViewSupplementaryExtender alloc] initWithHeaderFactory:headerFactoryMock
                                                                   footerFactory:footerFactoryMock];
});

describe(@"Init", ^{
    it(@"Returns object", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[TECCollectionViewSupplementaryExtender class]];
    });
});

describe(@"Supplementary views creation", ^{
    let(indexPathMock, ^id{
        id mock = [NSIndexPath mock];
        [mock stub:@selector(section) andReturn:theValue(15)];
        return mock;
    });
    
    let(collectionViewMock, ^id{
        return [UICollectionView mock];
    });
    
    let(viewMock, ^UICollectionReusableView *{
        return [UICollectionReusableView new];
    });
    
    let(sectionMock, ^id{
        id mock = [KWMock mockForProtocol:@protocol(TECSectionModelProtocol)];
        [mock stub:@selector(headerTitle) andReturn:@"header title"];
        [mock stub:@selector(footerTitle) andReturn:@"footer title"];
        return mock;
    });
    
    let(contentProviderMock, ^id{
        id mock = [KWMock mockForProtocol:@protocol(TECContentProviderProtocol)];
        [mock stub:@selector(sectionAtIndex:) andReturn:sectionMock withArguments:theValue(15)];
        return mock;
    });
    
    beforeEach(^{
        sut.extendedView = collectionViewMock;
        sut.contentProvider = contentProviderMock;
    });
    
    it(@"Should request header factory to get header", ^{
        NSString *kind = UICollectionElementKindSectionHeader;
        [headerFactoryMock stub:@selector(viewForItem:atIndexPath:) andReturn:viewMock withArguments:@"header title", indexPathMock];
        id result = [sut collectionView:collectionViewMock viewForSupplementaryElementOfKind:kind atIndexPath:indexPathMock];
        [[result should] beIdenticalTo:viewMock];
    });
    
    it(@"Should request footer factory to get footer", ^{
        NSString *kind = UICollectionElementKindSectionFooter;
        [footerFactoryMock stub:@selector(viewForItem:atIndexPath:) andReturn:viewMock withArguments:@"footer title", indexPathMock];
        id result = [sut collectionView:collectionViewMock viewForSupplementaryElementOfKind:kind atIndexPath:indexPathMock];
        [[result should] beIdenticalTo:viewMock];
    });
    
    it(@"Should return nil for unknown kind", ^{
        NSString *kind = @"Some unreadable kind";
        id result = [sut collectionView:collectionViewMock viewForSupplementaryElementOfKind:kind atIndexPath:indexPathMock];
        [[result should] beNil];
    });
});

SPEC_END
