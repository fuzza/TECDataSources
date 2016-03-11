//
//  TECTableViewCellExtender.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewCellExtender.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"
#import "TECReusableViewFactoryProtocol.h"

@interface TECTableViewCellExtender()

@property (nonatomic, strong) id <TECReusableViewFactoryProtocol> cellFactory;

@end

@implementation TECTableViewCellExtender

+ (instancetype)cellExtenderWithCellFactory:(id <TECReusableViewFactoryProtocol>)cellFactory {
    return [[self alloc] initWithCellFactory:cellFactory];
}

- (instancetype)initWithCellFactory:(id <TECReusableViewFactoryProtocol>)cellFactory {
    NSParameterAssert(cellFactory);
    self = [super init];
    if(self) {
        self.cellFactory = cellFactory;
    }
    return self;
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentProvider numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.contentProvider itemAtIndexPath:indexPath];
    UITableViewCell *cell = (UITableViewCell *)[self.cellFactory viewForItem:item atIndexPath:indexPath];
    NSAssert([cell isKindOfClass:[UITableViewCell class]], @"Cell returned from factory is not UITableViewCell subclass");
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.contentProvider numberOfSections];
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.contentProvider itemAtIndexPath:indexPath];
    [self.cellFactory configureView:cell forItem:item atIndexPath:indexPath];
}

@end
