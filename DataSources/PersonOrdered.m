//
//  PersonOrdered.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "PersonOrdered.h"

@implementation PersonOrdered

// Insert code here to add functionality to your managed object subclass

- (NSString *)firstAlphaCapitalized {
    return [[self.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
}

@end
