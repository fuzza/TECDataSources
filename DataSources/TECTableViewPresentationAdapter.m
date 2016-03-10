//
//  TECTableViewDataSource.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/26/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewPresentationAdapter.h"
#import "TECContentProviderProtocol.h"
#import "TECSectionModelProtocol.h"

#import "TECDelegateProxy.h"
#import "TECTableViewExtender.h"

@interface TECTableViewPresentationAdapter ()

@property (nonatomic, strong, readwrite) UITableView *extendedView;

@property (nonatomic, strong) id <TECContentProviderProtocol> contentProvider;

@property (nonatomic, strong) TECDelegateProxy <id <UITableViewDelegate, UITableViewDataSource>> *delegateProxy;
@property (nonatomic, strong) NSMutableArray <TECTableViewExtender *> *extenders;

@end

@implementation TECTableViewPresentationAdapter

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
        
        self.extendedView = tableView;
        
        [self addExtenders:extenders];
        
        self.extendedView.dataSource = [self.delegateProxy proxy];
        self.extendedView.delegate = [self.delegateProxy proxy];
    }
    return self;
}

- (void)dealloc {
    [self cleanup];
}

- (void)cleanup {
    self.extendedView.dataSource = nil;
    self.extendedView.delegate = nil;
}

#pragma mark - Extenders configuration

- (void)addExtenders:(NSArray <TECTableViewExtender *> *)extenders {
    for(TECTableViewExtender *extender in extenders) {
        [self addExtender:extender];
    }
}

- (void)addExtender:(TECTableViewExtender *)extender {
    NSParameterAssert(self.extendedView);
    NSParameterAssert(self.contentProvider);
    extender.extendedView = self.extendedView;
    extender.contentProvider = self.contentProvider;
    [self.delegateProxy attachDelegate:extender];
    [self.extenders addObject:extender];
}

#pragma mark - ContentProviderPresentationAdapter

- (void)contentProviderDidReloadData:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView reloadData];
}

- (void)contentProviderWillChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView beginUpdates];
}

- (void)contentProviderDidChangeItem:(id<TECSectionModelProtocol>)section
                         atIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)newIndexPath {
    switch (changeType) {
        case TECContentProviderItemChangeTypeDelete:
            [self.extendedView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderItemChangeTypeInsert:
            [self.extendedView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderItemChangeTypeMove:
            [self.extendedView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case TECContentProviderItemChangeTypeUpdate:
            [self.extendedView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)contentProviderDidChangeSection:(id<TECSectionModelProtocol>)section
                                atIndex:(NSUInteger)index
                          forChangeType:(TECContentProviderSectionChangeType)changeType {
    switch (changeType) {
        case TECContentProviderSectionChangeTypeInsert:
            [self.extendedView insertSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderSectionChangeTypeDelete:
            [self.extendedView deleteSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TECContentProviderSectionChangeTypeUpdate:
            [self.extendedView reloadSections:[NSIndexSet indexSetWithIndex:index]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider {
    [self.extendedView endUpdates];
}

@end
