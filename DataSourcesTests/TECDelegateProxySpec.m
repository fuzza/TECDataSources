//
//  TECDelegateProxySpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECDelegateProxy.h"
#import "TECDelegateProxyTestModels.h"

SPEC_BEGIN(TECDelegateProxySpec)

void (^attachDelegatesBlock)(TECDelegateProxy *proxy ,NSArray *delegates) = ^(TECDelegateProxy *proxy, NSArray *delegates) {
    for(id delegate in delegates) {
        [proxy attachDelegate:delegate];
    }
};

describe(@"TECDelegateProxy", ^{
    
    let(voidInvocationMock, ^id{
        id voidMethodSignatureMock = [NSMethodSignature mock];
        [voidMethodSignatureMock stub:@selector(methodReturnLength) andReturn:theValue(0)];
        
        id invocationMock = [NSInvocation mock];
        [invocationMock stub:@selector(methodSignature) andReturn:voidMethodSignatureMock];
        [invocationMock stub:@selector(selector) andReturn:theValue(@selector(tec_testMethod))];
        return invocationMock;
    });
    
    let(valueInvocationMock, ^id{
        id methodSignatureMock = [NSMethodSignature mock];
        [methodSignatureMock stub:@selector(methodReturnLength) andReturn:theValue(25)];
        
        id invocationMock = [NSInvocation mock];
        [invocationMock stub:@selector(methodSignature) andReturn:methodSignatureMock];
        [invocationMock stub:@selector(selector) andReturn:theValue(@selector(tec_testMethodWithReturnedValue))];
        
        return invocationMock;
    });
    
    let(sut, ^TECDelegateProxy *(){
        return [[TECDelegateProxy alloc] init];
    });
    
    context(@"One of delegates conforms protocol", ^{
        let(delegates, ^id{
            return @[[TECDelegateProxyEmptyTestModel new],
                     [TECDelegateProxyProtocolConformingTestModel new],
                     [TECDelegateProxyEmptyTestModel new]];
        });
        
        beforeEach(^{
            attachDelegatesBlock(sut, delegates);
        });
        
        it(@"Should conform protocol", ^{
            BOOL result = [sut conformsToProtocol:@protocol(TECDelegateProxyTestProtocol)];
            [[theValue(result) should] beTrue];
        });
    });
    
    context(@"None of delegates conforms protocol or responds to selector", ^{
        let(nonRespondingDelegates, ^id{
            return @[[TECDelegateProxyEmptyTestModel new],
                     [TECDelegateProxyEmptyTestModel new]];
        });
        
        beforeEach(^{
            attachDelegatesBlock(sut, nonRespondingDelegates);
        });

        it(@"Shouldn't conform protocol", ^{
            BOOL result = [sut conformsToProtocol:@protocol(TECDelegateProxyTestProtocol)];
            [[theValue(result) should] beFalse];

        });
        
        it(@"Shouldn't respond to selector", ^{
            BOOL result = [sut respondsToSelector:@selector(tec_testMethod)];
            [[theValue(result) should] beFalse];
        });
        
        it(@"Shouldn't return method signature", ^{
            id result = [sut methodSignatureForSelector:@selector(tec_testMethod)];
            [[result should] beNil];
        });
        
        it(@"Shouldn't forward message for any invocation", ^{
            [[voidInvocationMock shouldNot] receive:@selector(invokeWithTarget:)];
            [sut forwardInvocation:voidInvocationMock];
            
            [[valueInvocationMock shouldNot] receive:@selector(invokeWithTarget:)];
            [sut forwardInvocation:valueInvocationMock];
        });
    });
    
    context(@"One delegate respond to selectors", ^{
        let(singleRespondingDelegates, ^id{
            return @[[TECDelegateProxyEmptyTestModel new],
                     [TECDelegateProxySelectorTestModel new],
                     [TECDelegateProxyEmptyTestModel new]];
        });
        
        beforeEach(^{
            attachDelegatesBlock(sut, singleRespondingDelegates);
        });
        
        it(@"Should respond to selector", ^{
            BOOL result = [sut respondsToSelector:@selector(tec_testMethod)];
            [[theValue(result) should] beTrue];
        });
        
        it(@"Should return method signature", ^{
            id result = [sut methodSignatureForSelector:@selector(tec_testMethod)];
            [[result shouldNot] beNil];
        });
        
        it(@"Should forward message for any invocation", ^{
            [[voidInvocationMock should] receive:@selector(invokeWithTarget:)];
            [sut forwardInvocation:voidInvocationMock];
            
            [[valueInvocationMock should] receive:@selector(invokeWithTarget:)];
            [sut forwardInvocation:valueInvocationMock];
        });
    });
    
    context(@"Multiple delegates respond to selector", ^{
        let(multipleRespondingDelegates, ^id{
            return @[[TECDelegateProxyEmptyTestModel new],
                     [TECDelegateProxySelectorTestModel new],
                     [TECDelegateProxyEmptyTestModel new],
                     [TECDelegateProxySelectorTestModel new]];
        });

        beforeEach(^{
            attachDelegatesBlock(sut, multipleRespondingDelegates);
        });
        
        it(@"Should respond to selector", ^{
            BOOL result = [sut respondsToSelector:@selector(tec_testMethod)];
            [[theValue(result) should] beTrue];
        });
        
        it(@"Should return method signature", ^{
            id result = [sut methodSignatureForSelector:@selector(tec_testMethod)];
            [[result shouldNot] beNil];
        });
        
        it(@"Should forward message for void invocation to every delegate", ^{
            [[voidInvocationMock should] receive:@selector(invokeWithTarget:) withCount:2];
            [sut forwardInvocation:voidInvocationMock];
        });
        
        it(@"Should assert for invocation that returns", ^{
            void(^block)() = ^() {
                [sut forwardInvocation:valueInvocationMock];
            };
#ifndef DNS_BLOCK_ASSERTIONS
            [[theBlock(block) should] raise];
#else
            [[theBlock(block) shouldNot] raise];
#endif
        });
    });
    

});

SPEC_END
