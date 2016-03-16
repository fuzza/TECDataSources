//
//  TECScrollViewHelperSpec.m
//  DataSources
//
//  Created by Alexey Fayzullov on 3/16/16.
//  Copyright 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECScrollViewHelper.h"

SPEC_BEGIN(TECScrollViewHelperSpec)

let(scrollViewMock, ^id{
    return [UIScrollView mock];
});

describe(@"Scroll progress for top threshold", ^{
    void(^verifyProgress)(CGPoint,
                          CGFloat,
                          CGFloat) = ^(CGPoint offset, CGFloat threshold, CGFloat expectation) {
        [scrollViewMock stub:@selector(contentOffset) andReturn:theValue(offset)];
        CGFloat result = [TECScrollViewHelper scrollProgressForTopThreshold:threshold scrollView:scrollViewMock];
        [[theValue(result) should] equal:theValue(expectation)];
    };
    
    context(@"Pulling from zero to minus threshold", ^{
        it(@"Returns progress between 0 and 1", ^{
            verifyProgress(CGPointMake(0, -30), 50, 0.6);
        });
        
        it(@"Rounds progress to 2 digits after zero", ^{
            verifyProgress(CGPointMake(0, -23), 55, 0.42);
        });
    });
    
    context(@"Pulling from minus threshold", ^{
        it(@"Returns 1 if reach threshold", ^{
            verifyProgress(CGPointMake(0, -17), 17, 1);
        });
        
        it(@"Returns 1 if pull above threshold", ^{
            verifyProgress(CGPointMake(0, -400), 45, 1);
        });
    });
    
    context(@"Scrolling from zero", ^{
        it(@"Returns zero on zero offset", ^{
            verifyProgress(CGPointMake(0, 0), 40, 0);
        });
        
        it(@"Returns zeo on positive offset", ^{
            verifyProgress(CGPointMake(0, 25), 40, 0);
        });
    });
});

describe(@"Top inset modification", ^{
    it(@"Should set top inset without affecting other", ^{
        UIEdgeInsets initialInset = UIEdgeInsetsMake(0, 14, 15, 25);
        UIEdgeInsets expectedInset = UIEdgeInsetsMake(30, 14, 15, 25);
        
        [scrollViewMock stub:@selector(contentInset) andReturn:theValue(initialInset)];
        [[scrollViewMock should] receive:@selector(setContentInset:) withArguments:theValue(expectedInset)];
        
        [TECScrollViewHelper modifyTopInset:30 scrollView:scrollViewMock];
    });
});

SPEC_END
