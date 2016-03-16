//
//  TECPresentationAdapterDecoratorSpec.m
//  DataSources
//
//  Created by Petro Korienev on 3/15/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECPresentationAdapterDecorator.h"
#import "TECTableViewPresentationAdapter.h"
#import "TECContentProviderProtocol.h"

@interface TECPresentationAdapterDecorator (Test)

- (void)stealContentProviderDelegationFromPresentationAdapter;

@end

SHARED_EXAMPLES_BEGIN(TECPresentationAdapterDecoratorSpec)

sharedExamplesFor(@"TECPresentationAdapterDecorator", ^(NSDictionary *data) {

    let(sutClass, ^Class {return data[@"class"];});
    let(tablePresentationAdapterMock, ^TECTableViewPresentationAdapter *{return [TECTableViewPresentationAdapter nullMock];});
    let(presentationAdapterMock, ^TECPresentationAdapter *{return [TECPresentationAdapter nullMock];});
    let(contentProviderMock, ^KWMock<TECContentProviderProtocol> *{return [KWMock nullMockForProtocol:@protocol(TECContentProviderProtocol)];});
    
    describe([NSString stringWithFormat:@"%@ inherited from TECPresentationAdapterDecorator", sutClass], ^() {
        
        context(@"when initialized with TECPresentationAdapter subclass", ^() {
    #ifndef DNS_BLOCK_ASSERTIONS
            it(@"should not assert on init", ^() {
                [[theBlock(^() {
                    id __unused decorator =
                    [[sutClass alloc] initWithPresentationAdapter:tablePresentationAdapterMock];
                }) shouldNot] raise];
            });
    #endif
            
            it(@"should proxy content provider presentation adapter protocol methods", ^() {
                KWNilMatcher *nilMatcher = [KWNilMatcher new];
                [nilMatcher beNil];
                TECPresentationAdapterDecorator<TECContentProviderPresentationAdapterProtocol> *decorator =
                [[sutClass alloc] initWithPresentationAdapter:tablePresentationAdapterMock];
                [[tablePresentationAdapterMock should] receive:@selector(contentProviderDidReloadData:) withArguments:contentProviderMock];
                [[tablePresentationAdapterMock should] receive:@selector(contentProviderWillChangeContent:) withArguments:contentProviderMock];
                [[tablePresentationAdapterMock should] receive:@selector(contentProviderDidChangeContent:) withArguments:contentProviderMock];
                [[tablePresentationAdapterMock should] receive:@selector(contentProviderDidChangeSection:atIndex:forChangeType:) withArguments:nilMatcher, theValue(0), theValue(TECContentProviderSectionChangeTypeInsert)];
                [[tablePresentationAdapterMock should] receive:@selector(contentProviderDidChangeItem:atIndexPath:forChangeType:newIndexPath:) withArguments:nilMatcher, nilMatcher, theValue(TECContentProviderItemChangeTypeInsert), nilMatcher];
                [decorator contentProviderDidReloadData:contentProviderMock];
                [decorator contentProviderWillChangeContent:contentProviderMock];
                [decorator contentProviderDidChangeSection:nil
                                                   atIndex:0
                                             forChangeType:TECContentProviderSectionChangeTypeInsert];
                [decorator contentProviderDidChangeItem:nil
                                            atIndexPath:nil
                                          forChangeType:TECContentProviderItemChangeTypeInsert
                                           newIndexPath:nil];
                [decorator contentProviderDidChangeContent:contentProviderMock];
            });
            
            it(@"should proxy method that defined on presentation adapter to presentation adapter", ^() {
                TECPresentationAdapterDecorator<TECContentProviderPresentationAdapterProtocol> *decorator =
                [[sutClass alloc] initWithPresentationAdapter:tablePresentationAdapterMock];
                [[tablePresentationAdapterMock should] receive:@selector(extendedView) withArguments:theValue(YES)];
                [decorator extendedView];
            });
            
            it(@"should not proxy method that is not defined on presentation adapter to presentation adapter", ^() {
                TECPresentationAdapterDecorator<TECContentProviderPresentationAdapterProtocol> *decorator =
                [[sutClass alloc] initWithPresentationAdapter:tablePresentationAdapterMock];
                [[tablePresentationAdapterMock should] receive:@selector(extendedView) withArguments:theValue(YES)];
                [decorator extendedView];
            });
        });
        
        context(@"when initialized with TECPresentationAdapter instance", ^() {
    #ifndef DNS_BLOCK_ASSERTIONS
            it(@"should assert on init", ^() {
                [[theBlock(^() {
                    id __unused decorator =
                    [[sutClass alloc] initWithPresentationAdapter:presentationAdapterMock];
                }) should] raise];
            });
    #endif
        });
        
        context(@"when initialized with nil", ^() {
    #ifndef DNS_BLOCK_ASSERTIONS
            it(@"should assert on init", ^() {
                [[theBlock(^() {
                    id __unused decorator =
                    [[sutClass alloc] initWithPresentationAdapter:nil];
                }) should] raise];
            });
    #endif
        });
        
        context(@"in any case", ^(){
            it(@"should not throw on isKindOfClass, just return NO", ^() {
                __block BOOL isKindOfClass = YES;
                [[theBlock(^() {
                    TECPresentationAdapterDecorator *decorator = [[sutClass alloc] initWithPresentationAdapter:tablePresentationAdapterMock];
                    isKindOfClass = [decorator isKindOfClass:[TECPresentationAdapterDecorator class]];
                }) shouldNot] raise];
                [[theValue(isKindOfClass) should] beNo];
            });
            
            it(@"should be proxy", ^() {
                __block BOOL isProxy = NO;
                [[theBlock(^() {
                    TECPresentationAdapterDecorator *decorator = [[sutClass alloc] initWithPresentationAdapter:tablePresentationAdapterMock];
                    isProxy = [decorator isProxy];
                }) shouldNot] raise];
                [[theValue(isProxy) should] beYes];
            });
        });
    });
});

SHARED_EXAMPLES_END