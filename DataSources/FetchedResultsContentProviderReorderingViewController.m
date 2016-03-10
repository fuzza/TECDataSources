//
//  FetchedResultsContentProviderReorderingViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultsContentProviderReorderingViewController.h"

#import "TECTableViewPresentationAdapter.h"

#import "TECFetchedResultsControllerContentProvider.h"

#import "TECTableViewCellRegistrationAdapter.h"
#import "TECSimpleReusableViewFactory.h"

#import "TECCustomCell.h"

#import "TECTableViewSectionHeaderExtender.h"
#import "TECTableViewSectionFooterExtender.h"
#import "TECTableViewCellExtender.h"
#import "TECTableViewEditingExtender.h"
#import "TECTableViewReorderingExtender.h"
#import "TECTableViewDeletingExtender.h"

#import "TECDelegateProxy.h"
#import "CoreDataManager.h"

#import "TECMainContextObjectGetter.h"
#import "TECBackgroundContextObjectMutator.h"

#import "PersonOrdered.h"

@interface FetchedResultsContentProviderReorderingViewController ()

@property (nonatomic, strong) TECMainContextObjectGetter *objectGetter;
@property (nonatomic, strong) TECBackgroundContextObjectMutator *objectMutator;

@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@end

@implementation FetchedResultsContentProviderReorderingViewController

- (void)setupTableController {
    TECTableViewCellRegistrationAdapter *adapter
    = [[TECTableViewCellRegistrationAdapter alloc] initWithTableView:self.tableView];
    
    TECSimpleReusableViewFactory<TECCustomCell *, PersonOrdered *> *factory = [[TECSimpleReusableViewFactory alloc] initWithRegistrationAdapter:adapter];
    [factory registerViewClass:[TECCustomCell class]];
    [factory setConfigurationHandler:^(TECCustomCell *cell, PersonOrdered *person, NSIndexPath *indexPath) {
        cell.textLabel.text = person.name;
    }];
    
    self.footerExtender = [TECTableViewSectionFooterExtender extender];
    self.headerExtender = [TECTableViewSectionHeaderExtender extender];
    
    self.cellExtender = [TECTableViewCellExtender cellExtenderWithCellFactory:factory];
    self.reorderingExtender =
    [TECTableViewReorderingExtender reorderingExtenderWithCanMoveBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    }
                                                  targetIndexPathBlock:nil];
    self.editingExtender = [TECTableViewEditingExtender editingExtenderWithCanEditBlock:^BOOL(UITableView *tableView, NSIndexPath *indexPath, id<TECSectionModelProtocol> section, id item) {
        return YES;
    }];
    self.deletingExtender = [TECTableViewDeletingExtender extender];
    
    self.objectGetter = [[CoreDataManager sharedObject] createObjectGetter];
    self.objectMutator = [[CoreDataManager sharedObject] createObjectMutator];
    
    NSFetchRequest *fetchRequest = [[CoreDataManager sharedObject] createPersonOrderedFetchRequest];
    
    self.contentProvider =
    [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:self.objectGetter
                                                               itemsMutator:self.objectMutator
                                                               fetchRequest:fetchRequest
                                                         sectionNameKeyPath:nil];
    __weak typeof(self) weakSelf = self;
    self.contentProvider.moveBlock = ^(NSFetchedResultsController *fetchedResultsController,
                                       NSIndexPath *from,
                                       NSIndexPath *to) {
        PersonOrdered *fromObj = [fetchedResultsController objectAtIndexPath:from];
        PersonOrdered *toObj = [fetchedResultsController objectAtIndexPath:to];
        NSInteger fromOrdinal = fromObj.ordinal.integerValue;
        NSInteger toOrdinal = toObj.ordinal.integerValue;
        NSInteger minOrdinal = MIN(fromOrdinal, toOrdinal);
        NSInteger maxOrdinal = MAX(fromOrdinal, toOrdinal);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ordinal <= %@ AND ordinal >= %@",
                                  @(maxOrdinal), @(minOrdinal)];
        NSArray *objects = [fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate];
        [weakSelf.objectMutator mutateObjects:objects
                                     ofEntity:fetchedResultsController.fetchRequest.entity
                                    withBlock:^(NSArray<PersonOrdered *> *objects, NSError *error)
        {
            [objects enumerateObjectsUsingBlock:^(PersonOrdered *obj, NSUInteger idx, BOOL *stop) {
                if (idx == 0 && maxOrdinal == toOrdinal) {
                    obj.ordinal = @(maxOrdinal);
                }
                else if (idx == objects.count - 1 && minOrdinal == toOrdinal) {
                    obj.ordinal = @(minOrdinal);
                }
                else {
                    obj.ordinal = @(obj.ordinal.integerValue + ((maxOrdinal == toOrdinal) ? -1 : 1));
                }
            }];
        }];
    };
    
    self.tableController =
    [[TECTableViewPresentationAdapter alloc] initWithContentProvider:self.contentProvider
                                              tableView:self.tableView
                                              extenders:@[
                                                          self.headerExtender,
                                                          self.footerExtender,
                                                          self.cellExtender,
                                                          self.editingExtender,
                                                          self.deletingExtender,
                                                          self.reorderingExtender]
                                          delegateProxy:[[TECDelegateProxy alloc] init]];
}

@end
