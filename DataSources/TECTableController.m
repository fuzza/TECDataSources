//
//  TECTableViewDataSource.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableController.h"
#import "TECTableViewCellFactoryProtocol.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"

#import "TECDelegateProxy.h"

#import "TECTableViewSectionHeaderExtender.h"

@interface TECTableController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) id <TECTableViewCellFactoryProtocol> cellFactory;
@property (nonatomic, strong) id <TECContentProviderProtocol> contentProvider;

@property (nonatomic, strong) TECDelegateProxy <id <UITableViewDelegate>> *delegateProxy;
@property (nonatomic, strong) TECDelegateProxy <id <UITableViewDataSource>> *dataSourceProxy;

@end

@implementation TECTableController

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                            cellFactory:(id <TECTableViewCellFactoryProtocol>)cellFactory {
    self = [super init];
    if(self) {
        self.contentProvider = contentProvider;
        self.cellFactory = cellFactory;
        
        self.delegateProxy = [[TECDelegateProxy alloc] initWithPrimaryDelegate:self];
        self.dataSourceProxy = [[TECDelegateProxy alloc] initWithPrimaryDelegate:self];
    }
    return self;
}

- (void)addExtender:(TECTableViewExtender *)extender {
    extender.tableView = self.tableView;
    extender.cellFactory = self.cellFactory;
    extender.contentProvider = self.contentProvider;
    
    [self.delegateProxy attachSecondaryDelegate:extender];
    [self.dataSourceProxy attachSecondaryDelegate:extender];
}

- (void)setupWithTableView:(UITableView *)tableView {
    self.tableView = tableView;
    self.tableView.dataSource = [self.dataSourceProxy proxy];
    self.tableView.delegate = [self.delegateProxy proxy];
}

- (void)dealloc {
    [self cleanup];
}

- (void)cleanup {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)reloadDataSourceWithCompletion:(TECTableCompletionBlock)completion {
    [self.tableView reloadData];
    if(completion) {
        completion();
    }
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentProvider numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.contentProvider itemAtIndexPath:indexPath];
    UITableViewCell *cell = [self.cellFactory cellForItem:item tableView:tableView atIndexPath:indexPath];
    return [self.cellFactory configureCell:cell forItem:item inTableView:tableView atIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.contentProvider numberOfSections];
}

#pragma mark - UITableViewDelegate protocol

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.contentProvider itemAtIndexPath:indexPath];
    [self.cellFactory configureCell:cell forItem:item inTableView:tableView atIndexPath:indexPath];
}

@end
