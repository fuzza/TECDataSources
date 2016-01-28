//
//  TECTableViewDataSource.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableController.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"

#import "TECDelegateProxy.h"
#import "TECTableViewExtender.h"

@interface TECTableController ()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) id <TECContentProviderProtocol> contentProvider;

@property (nonatomic, strong) TECDelegateProxy <id <UITableViewDelegate, UITableViewDataSource>> *delegateProxy;
@property (nonatomic, strong) NSArray <TECTableViewExtender *> *extenders;

@end

@implementation TECTableController

#pragma mark - Lifecycle

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider {
    self = [super init];
    if(self) {
        self.contentProvider = contentProvider;
        self.delegateProxy = [[TECDelegateProxy alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self cleanup];
}

- (void)cleanup {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Extenders configuration

- (void)addExtenders:(NSArray <TECTableViewExtender *> *)extenders {
    self.extenders = extenders;
    for(TECTableViewExtender *extender in self.extenders) {
        [self addExtender:extender];
    }
}

- (void)addExtender:(TECTableViewExtender *)extender {
    extender.tableView = self.tableView;
    extender.contentProvider = self.contentProvider;
    [self.delegateProxy attachDelegate:extender];
}

#pragma mark - Setup

- (void)setupWithTableView:(UITableView *)tableView {
    self.tableView = tableView;
    self.tableView.dataSource = [self.delegateProxy proxy];
    self.tableView.delegate = [self.delegateProxy proxy];
}

- (void)reloadDataSourceWithCompletion:(TECTableCompletionBlock)completion {
    [self.tableView reloadData];
    if(completion) {
        completion();
    }
}

@end
