//
//  TECTableViewCellRegistrator.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/21/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewCellRegistrator.h"

@interface TECTableViewCellRegistrator ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *registratorCache;
@property (nonatomic, copy) TECTableViewCellClassHandler classHandler;
@property (nonatomic, copy) TECTableViewCellReuseIdHandler reuseIdHandler;

@end

@implementation TECTableViewCellRegistrator

- (instancetype)initWithClassHandler:(TECTableViewCellClassHandler)classHandler
                      reuseIdHandler:(TECTableViewCellReuseIdHandler)reuseIdHandler {
    self = [super init];
    if(self) {
        NSParameterAssert(classHandler);
        NSParameterAssert(reuseIdHandler);
        
        self.classHandler = classHandler;
        self.reuseIdHandler = reuseIdHandler;
        
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults {
    self.registratorCache = [NSMutableDictionary new];
}

- (NSString *)cellReuseIdentifierForItem:(id)item
                               tableView:(UITableView *)tableView
                             atIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    NSParameterAssert(indexPath);
    
    Class cellClass = self.classHandler(item, indexPath);
    
    NSString *reuseIdentifier = self.reuseIdHandler(cellClass, item, indexPath);
    NSParameterAssert(reuseIdentifier);
    
    NSString *classString = [self.registratorCache objectForKey:reuseIdentifier];
    if(!classString) {
        [self registerCellClass:cellClass inTableView:tableView forReuseIdentifier:reuseIdentifier];
    }
    
    return reuseIdentifier;
}

- (Class)cellClassForItem:(id)item
                tableView:(UITableView *)tableView
              atIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = self.classHandler(item, indexPath);
    NSParameterAssert(cellClass);
    return cellClass;
}

- (void)registerCellClass:(Class)cellClass
              inTableView:(UITableView *)tableView
       forReuseIdentifier:(NSString *)reuseIdentifier {
    NSParameterAssert(cellClass);
    NSParameterAssert(reuseIdentifier);
    
    [tableView registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
    [self.registratorCache setObject:NSStringFromClass(cellClass) forKey:reuseIdentifier];
}

@end
