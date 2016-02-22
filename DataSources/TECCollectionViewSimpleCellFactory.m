//
//  TECCollectionViewSimpleFactory.m
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCollectionViewSimpleCellFactory.h"
#import "TECReusableViewRegistrationAdapterProtocol.h"

@interface TECCollectionViewSimpleCellFactory ()

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) NSString *reuseIdentifier;

@end

@implementation TECCollectionViewSimpleCellFactory

- (void)registerCellClass:(Class)aClass {
    NSParameterAssert([aClass isSubclassOfClass:[UICollectionViewCell class]]);
    NSAssert(self.cellClass == nil, @"Cell can be registered only once");
    
    self.cellClass = aClass;
    self.reuseIdentifier = NSStringFromClass(aClass);
    [self.registrationAdapter registerClass:self.cellClass
                         forReuseIdentifier:self.reuseIdentifier];
}

#pragma mark - TECReusableViewFactoryProtocol

- (UICollectionViewCell *)viewForItem:(id)item
            atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.cellClass, @"You must register cell before trying to dequeue");
    id cell = [self.registrationAdapter reuseViewWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    NSParameterAssert([cell isKindOfClass:[UICollectionViewCell class]]);
    return cell;
}

- (void)configureView:(UICollectionViewCell *)cell
              forItem:(id)item
          atIndexPath:(NSIndexPath *)indexPath {
    if(self.configurationHandler) {
        self.configurationHandler(cell, item, indexPath);
    }
}

@end
