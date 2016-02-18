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
@property (nonatomic, strong) NSMutableArray <TECTableViewExtender *> *extenders;

@end

@implementation TECTableController

#pragma mark - Lifecycle

- (instancetype)initWithContentProvider:(id <TECContentProviderProtocol>)contentProvider
                              tableView:(UITableView *)tableView
                              extenders:(NSArray<TECTableViewExtender *> *)extenders
                          delegateProxy:(TECDelegateProxy *)delegateProxy {
    self = [self init];
    if(self) {
        self.contentProvider = contentProvider;
        self.contentProvider.presentationAdapter = self;

        self.delegateProxy = delegateProxy;
        self.extenders = [NSMutableArray new];
        
        self.tableView = tableView;
        
        [self addExtenders:extenders];
        
        self.tableView.dataSource = [self.delegateProxy proxy];
        self.tableView.delegate = [self.delegateProxy proxy];
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
    for(TECTableViewExtender *extender in extenders) {
        [self addExtender:extender];
    }
}

- (void)addExtender:(TECTableViewExtender *)extender {
    NSParameterAssert(self.tableView);
    NSParameterAssert(self.contentProvider);
    extender.tableView = self.tableView;
    extender.contentProvider = self.contentProvider;
    [self.delegateProxy attachDelegate:extender];
    [self.extenders addObject:extender];
}

#pragma mark - ContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [self.tableView reloadData];
}

- (void)contentProviderWillChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [self.tableView beginUpdates];
}

- (void)contentProviderDidChangeItem:(id<TECSectionModelProtocol>)section
                         atIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)newIndexPath {
    switch (changeType) {
        case TECContentProviderItemChangeTypeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderItemChangeTypeInsert:
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderItemChangeTypeMove:
            [self.tableView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case TECContentProviderItemChangeTypeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)contentProviderDidChangeSection:(id<TECSectionModelProtocol>)section
                                atIndex:(NSUInteger)index
                          forChangeType:(TECContentProviderSectionChangeType)changeType {
    
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [self.tableView endUpdates];
}

@end
