//
//  TECReusableViewsRegistratorSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECReusableViewRegistrator.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

SPEC_BEGIN(TECReusableViewRegistratorSpec)

describe(@"TECReusableViewRegistrator", ^{
    let(sut, ^TECReusableViewRegistrator *{
        return [[TECReusableViewRegistrator alloc] init];
    });
    
    describe(@"Initialization", ^{
        it(@"Should return new instance", ^{
            [[sut shouldNot] beNil];
            [[sut should] beKindOfClass:[TECReusableViewRegistrator class]];
        });
        
        it(@"Should conform registrator protocol", ^{
            [[sut should] conformToProtocol:@protocol(TECReusableViewRegistratorProtocol)];
        });
    });
    
    describe(@"Reuse identifier obtaining", ^{
        let(itemMock, ^id{
            return [NSObject nullMock];
        });
        
        let(indexPathMock, ^id{
            return [NSIndexPath mock];
        });
        
        let(registrationAdapterMock, ^id{
            return [KWMock nullMockForProtocol:@protocol(TECReusableViewRegistrationAdapterProtocol)];
        });
        
        Class(^classHandler)(id, NSIndexPath *) = ^Class(id item, NSIndexPath *indexPath) {
            return [NSObject class];
        };

        NSString *(^identifierHandler)(Class, id, NSIndexPath *) = ^NSString *(Class viewClass, id item, NSIndexPath *indexPath) {
            return NSStringFromClass([NSObject class]);
        };
        
        beforeEach(^{
            sut.classHandler = classHandler;
            sut.identifierHandler = identifierHandler;
            sut.registrationAdapter = registrationAdapterMock;
        });
        
        #ifndef DNS_BLOCK_ASSERTIONS
        void(^verifyAssert)(id, NSIndexPath *) = ^(id item, NSIndexPath *indexPath) {
            [[theBlock(^{
                [sut reuseIdentifierForItem:item atIndexPath:indexPath];
            }) should] raise];
        };
        
        it(@"Should raise if class handler is missing", ^{
            sut.classHandler = nil;
            verifyAssert(itemMock, indexPathMock);
        });
        
        it(@"Should raise if reuse handler is mising", ^{
            sut.identifierHandler = nil;
            verifyAssert(itemMock, indexPathMock);
        });
        
        it(@"Should raise if item is missing", ^{
            verifyAssert(nil, indexPathMock);
        });
        
        it(@"Should raise if indexPath is missing", ^{
            verifyAssert(itemMock, nil);
        });
        
        it(@"Should raise if registration adapter is missing", ^{
            sut.registrationAdapter = nil;
            verifyAssert(itemMock, indexPathMock);
        });
        
        it(@"Should raise if class handler returns nil", ^{
            sut.classHandler = ^Class(id item, NSIndexPath *indexPath) {
                return nil;
            };
            verifyAssert(itemMock, indexPathMock);
        });
        
        it(@"Should raise if identifier handler returns nil", ^{
            sut.identifierHandler = ^NSString *(Class viewClass, id item, NSIndexPath *indexPath) {
                return nil;
            };
            verifyAssert(itemMock, indexPathMock);
        });
        #endif
        
        it(@"Should call handlers and return correct reuse identifier", ^{
            Class expectedClass = [NSLayoutConstraint class];
            NSString *reuseIdentifier = @"some expected reuse identifier";
            
            sut.classHandler = ^Class(id item, NSIndexPath *indexPath) {
                [[item should] equal:itemMock];
                [[indexPath should] equal:indexPathMock];
                return expectedClass;
            };
            
            sut.identifierHandler = ^NSString *(Class viewClass, id item, NSIndexPath *indexPath) {
                [[viewClass should] equal:expectedClass];
                [[item should] equal:itemMock];
                [[indexPath should] equal:indexPathMock];
                return reuseIdentifier;
            };
            
            NSString *result = [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
            [[result should] equal:reuseIdentifier];
        });

        it(@"Should register class and identifier in adapter only once", ^{
            Class expectedClass = [NSLayoutConstraint class];
            NSString *reuseIdentifier = @"test reuse identifier";
            
            [[registrationAdapterMock should] receive:@selector(registerClass:forReuseIdentifier:) withArguments:expectedClass, reuseIdentifier];
            
            sut.classHandler = ^Class(id item, NSIndexPath *indexPath) {
                return expectedClass;
            };
            
            sut.identifierHandler = ^NSString *(Class viewClass, id item, NSIndexPath *indexPath) {
                return reuseIdentifier;
            };

            NSString *firstResult = [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
            NSString *secondResult = [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
            
            [[firstResult should] equal:reuseIdentifier];
            [[secondResult should] equal:secondResult];
        });
        
        describe(@"View registration in adapter", ^{
            let(expectedClass, ^Class{
                return [NSLayoutConstraint class];
            });
            
            let(reuseIdentifier, ^NSString *{
                return @"test reuse identifier";
            });
            
            beforeEach(^{
                sut.classHandler = ^Class(id item, NSIndexPath *indexPath) {
                    return expectedClass;
                };
                sut.identifierHandler = ^NSString *(Class viewClass, id item, NSIndexPath *indexPath) {
                    return reuseIdentifier;
                };
                sut.registrationAdapter = registrationAdapterMock;
            });
            
            it(@"Should register class and identifier in adapter only once", ^{
                [[registrationAdapterMock should] receive:@selector(registerClass:forReuseIdentifier:) withArguments:expectedClass, reuseIdentifier];
                [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
                [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
                [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
            });
            
            it(@"Should return the same value for repeating registrations", ^{
                id result1 = [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
                id result2 = [sut reuseIdentifierForItem:itemMock atIndexPath:indexPathMock];
                
                [[result1 should] equal:reuseIdentifier];
                [[result1 should] equal:result2];
            });
            
        });
        
        
    });
});

SPEC_END
