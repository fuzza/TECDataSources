//
//  KiwiWorkarounds.m
//  TECDataSources
//
//  Created by Petro Korienev on 3/14/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Kiwi/Kiwi.h>

// As of version 2.0 of Kiwi, Kiwi doesn't support predefined matchers to be evaluated as an argument filters.
// Make every matcher generic by implementing KWGenericMatching protocol

@interface KWMatcher (GenericMatcher) <KWGenericMatching>

@end

@implementation KWMatcher (GenericMatcher)

- (BOOL)matches:(id)object {
    self.subject = object;
    return [self evaluate];
}

@end
