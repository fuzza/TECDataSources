//
//  TECCellRegistrator.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECReusableViewRegistrator.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECReusableViewRegistrator ()

@property (nonatomic, strong) NSMutableDictionary *registeredViewsCache;

@end

@implementation TECReusableViewRegistrator

@synthesize registrationAdapter = _registrationAdapter;

- (NSString *)reuseIdentifierForItem:(id)item
                             atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    NSParameterAssert(indexPath);
    NSParameterAssert(self.classHandler);
    NSParameterAssert(self.identifierHandler);
    NSParameterAssert(self.registrationAdapter);
    
    Class viewClass = self.classHandler(item, indexPath);
    NSParameterAssert(viewClass);
    
    NSString *reuseIdentifier = self.identifierHandler(viewClass, item, indexPath);
    NSParameterAssert(reuseIdentifier);
    
    [self registerViewClassInAdapter:viewClass forReuseIdentifier:reuseIdentifier];
    return reuseIdentifier;
}

- (void)registerViewClassInAdapter:(Class)aClass forReuseIdentifier:(NSString *)identifier {
    if(![self.registeredViewsCache objectForKey:identifier]) {
        [self.registeredViewsCache setObject:NSStringFromClass(aClass) forKey:identifier];
        [self.registrationAdapter registerClass:aClass forReuseIdentifier:identifier];
    }
}

- (NSMutableDictionary *)registeredViewsCache {
    if(!_registeredViewsCache) {
        _registeredViewsCache = [NSMutableDictionary new];
    }
    return _registeredViewsCache;
}

@end
