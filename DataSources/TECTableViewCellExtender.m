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
#import "TECTableViewCellFactoryProtocol.h"

TECTableViewExtenderInterfaceExtension(TECTableViewCellExtender)

@property (nonatomic, strong) id <TECTableViewCellFactoryProtocol> cellFactory;

TECTableViewExtenderEnd

TECTableViewExtenderImplementation(TECTableViewCellExtender)

+ (instancetype)cellExtenderWithCellFactory:(id <TECTableViewCellFactoryProtocol>)cellFactory {
    return [[self alloc] initWithCellFactory:cellFactory];
}

- (instancetype)initWithCellFactory:(id <TECTableViewCellFactoryProtocol>)cellFactory {
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
    UITableViewCell *cell = [self.cellFactory cellForItem:item tableView:tableView atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.contentProvider numberOfSections];
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.contentProvider itemAtIndexPath:indexPath];
    [self.cellFactory configureCell:cell forItem:item inTableView:tableView atIndexPath:indexPath];
}

TECTableViewExtenderEnd
