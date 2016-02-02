//
//  TECMemoryContentProviderSpec.m
//  DataSources
//
//  Created by Petro Korienev on 2/2/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TECMemoryContentProvider.h"

@interface TECMemoryContentProvider (Test)

@property (nonatomic, strong, readwrite) NSArray *sections;

@end

SPEC_BEGIN(TECMemoryContentProviderSpec)

describe(@"TECMemoryContentProvider initialization", ^() {
    
    it(@"should correctly initialize items array calling -initWithItems:", ^() {
    });
});

describe(@"Cocoa collection support", ^() {

    it(@"should correctly count items", ^() {
    });
    
    it(@"should return section within bracketed notation for index", ^() {
    });
    
    it(@"should return object within bracketed notation for key", ^() {
    });
    
    it(@"should enumerate objects with for-in construct", ^() {
    });
    
    it(@"should return section enumerator", ^() {
    });
    
    it(@"should return reverse section enumerator", ^() {
    });
    
    it(@"should enumerate sections via direct enumerator", ^() {
    });
    
    it(@"should enumerate sections via reverse enumerator", ^() {
    });
    
    it(@"should enumerate sections via block directly", ^() {
    });
    
    it(@"should enumerate sections via block in reverse order", ^() {
    });
    
    it(@"should enumerate sections via block concurrently", ^() {
    });
    
    it(@"should enumerate sections via block concurrently in reverse order", ^() {
    });
    
    it(@"should respect stop parameter when enumerating directly", ^() {
    });
    
    it(@"should respect stop parameter when enumerating in reverse order", ^() {
    });
});

SPEC_END
