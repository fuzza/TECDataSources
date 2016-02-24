//
//  TECCollectionViewSimpleFactory.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECSimpleReusableViewFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECSimpleReusableViewFactory ()

@property (nonatomic, strong) TECSimpleReusableViewFactoryConfigurationHandler configurationHandler;
@property (nonatomic, strong) Class viewClass;
@property (nonatomic, strong) NSString *reuseIdentifier;

@end

@implementation TECSimpleReusableViewFactory

- (void)registerViewClass:(Class)aClass {
    NSParameterAssert(aClass);
    NSAssert(self.viewClass == nil, @"View can be registered only once");
    
    self.viewClass = aClass;
    self.reuseIdentifier = NSStringFromClass(aClass);
    [self.registrationAdapter registerClass:self.viewClass
                         forReuseIdentifier:self.reuseIdentifier];
}

#pragma mark - TECReusableViewFactoryProtocol

- (id)viewForItem:(id)item
            atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.viewClass, @"You must register view before dequeue");
    id view = [self.registrationAdapter reuseViewWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    NSParameterAssert([view isMemberOfClass:self.viewClass]);
    return view;
}

- (void)configureView:(id)view
              forItem:(id)item
          atIndexPath:(NSIndexPath *)indexPath {
    if(self.configurationHandler) {
        self.configurationHandler(view, item, indexPath);
    }
}

@end
