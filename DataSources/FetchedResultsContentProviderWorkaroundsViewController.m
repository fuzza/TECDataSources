//
//  FetchedResultsContentProviderWorkaroundsViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/20/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultsContentProviderWorkaroundsViewController.h"

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

#import "Person.h"

@interface FetchedResultsContentProviderWorkaroundsViewController ()

@property (nonatomic, strong) UIBarButtonItem *workaround1ButtonItem;
@property (nonatomic, strong) UIBarButtonItem *workaround2ButtonItem;
@property (nonatomic, strong) UIBarButtonItem *workaround3ButtonItem;
@property (nonatomic, strong) UIBarButtonItem *helpButtonItem;
@property (nonatomic, strong) TECMainContextObjectGetter *objectGetter;
@property (nonatomic, strong) TECBackgroundContextObjectMutator *objectMutator;

@property (nonatomic, strong) TECFetchedResultsControllerContentProvider *contentProvider;

@property (nonatomic, assign) BOOL isHelpShown;
@property (nonatomic, weak) IBOutlet UITextView *helpTextView;

@end

@implementation FetchedResultsContentProviderWorkaroundsViewController

- (void)setupToolbar {
    self.toolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    self.workaround1ButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:self action:@selector(workaround1ButtonItemPressed:)];
    self.workaround2ButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"2(5)" style:UIBarButtonItemStylePlain target:self action:@selector(workaround2ButtonItemPressed:)];
    self.workaround3ButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"3" style:UIBarButtonItemStylePlain target:self action:@selector(workaround3ButtonItemPressed:)];
    self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.helpButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStylePlain target:self action:@selector(helpButtonPressed:)];
    self.closeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonPressed:)];
    self.toolbar.items = @[self.workaround1ButtonItem, self.workaround2ButtonItem, self.workaround3ButtonItem, self.flexibleSpace, self.helpButtonItem, self.closeButtonItem];
    [self.view addSubview:self.toolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [self closeHelpAnimated:NO];
}

- (void)setupTableController {
    TECTableViewCellRegistrationAdapter *adapter
    = [[TECTableViewCellRegistrationAdapter alloc] initWithTableView:self.tableView];
    
    TECSimpleReusableViewFactory<TECCustomCell *, Person *> *factory = [[TECSimpleReusableViewFactory alloc] initWithRegistrationAdapter:adapter];
    [factory registerViewClass:[TECCustomCell class]];
    [factory setConfigurationHandler:^(TECCustomCell *cell, Person *person, NSIndexPath *indexPath) {
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
    
    NSFetchRequest *fetchRequest = [[CoreDataManager sharedObject] createPersonFetchRequest];
    
    self.contentProvider =
    [[TECFetchedResultsControllerContentProvider alloc] initWithItemsGetter:self.objectGetter
                                                               itemsMutator:self.objectMutator
                                                               fetchRequest:fetchRequest
                                                         sectionNameKeyPath:@"firstAlphaCapitalized"];
    
    self.tableController =
    [[TECTableViewPresentationAdapter alloc] initWithContentProvider:self.contentProvider
                                                        extendedView:self.tableView
                                                           extenders:@[
                                                                       self.headerExtender,
                                                                       self.footerExtender,
                                                                       self.cellExtender,
                                                                       self.editingExtender,
                                                                       self.deletingExtender,
                                                                       self.reorderingExtender]
                                                       delegateProxy:[[TECDelegateProxy alloc] init]];
}

- (void)workaround1ButtonItemPressed:(id)sender {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Person class])];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"Alexey Fayzullov"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    fetchRequest.fetchLimit = 1;
    [self.objectGetter fetchItemsForFetchRequest:fetchRequest
                                       withBlock:^(NSArray<NSManagedObject *> *objects, NSError *error)
     {
         [self.objectMutator mutateObjects:objects
                                  ofEntity:objects.firstObject.entity
                                 withBlock:^(NSArray<Person *> *objects, NSError *error)
          {
              objects.firstObject.name = [NSString stringWithFormat:@"%@ %@", @"Anastasiya Z", objects.firstObject.name];
              objects.firstObject.phone = [objects.firstObject.phone stringByAppendingString:@"1"];
          }];
     }];
}

- (void)workaround2ButtonItemPressed:(id)sender {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Person class])];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS %@) OR (name CONTAINS %@)", @"Petro Korienev", @"Sergey Zenchenko"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    fetchRequest.fetchLimit = 2;
    [self.objectGetter fetchItemsForFetchRequest:fetchRequest
                                       withBlock:^(NSArray<NSManagedObject *> *objects, NSError *error)
    {
        [self.objectMutator mutateObjects:objects
                                 ofEntity:objects.firstObject.entity
                                withBlock:^(NSArray<Person *> *objects, NSError *error)
        {
            [objects enumerateObjectsUsingBlock:^(Person *person, NSUInteger idx, BOOL *stop) {
                person.name = [NSString stringWithFormat:@"%@%@", ((idx % 2) == 0) ? @"U" : @"V", person.name];
            }];
        }];
    }];
}

- (void)workaround3ButtonItemPressed:(id)sender {
    
}

- (void)helpButtonPressed:(id)sender {
    if (self.isHelpShown) {
        [self closeHelpAnimated:YES];
    }
    else {
        [self showHelpAnimated:YES];
    }
}

- (void)closeButtonPressed:(id)sender {
    if (self.isHelpShown) {
        [self closeHelpAnimated:YES];
    }
    else {
        [super closeButtonPressed:sender];
    }
}

- (void)closeHelpAnimated:(BOOL)animated {
    void(^block)() = ^() {
        CGRect frame = self.tableView.frame;
        frame.origin.y += frame.size.height;
        frame.size.height = 0;
        self.helpTextView.frame = frame;
        self.helpTextView.alpha = 0.0f;
        [self.view bringSubviewToFront:self.helpTextView];
    };
    if (animated) {
        [UIView animateWithDuration:0.3 animations:block];
    }
    else {
        block();
    }
    [self.toolbar setItems:@[self.workaround1ButtonItem, self.workaround2ButtonItem, self.workaround3ButtonItem, self.flexibleSpace, self.helpButtonItem, self.closeButtonItem] animated:animated];
    self.isHelpShown = NO;
}

- (void)showHelpAnimated:(BOOL)animated {
    void(^block)() = ^() {
        CGRect frame = self.tableView.frame;
        self.helpTextView.frame = frame;
        [self.view bringSubviewToFront:self.helpTextView];
        self.helpTextView.alpha = 1.0f;
    };
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:block
                         completion:^(BOOL finished)
        {
            [self.helpTextView setContentOffset:CGPointZero animated:NO];
        }];
    }
    else {
        block();
    }
    [self.toolbar setItems:@[self.flexibleSpace, self.closeButtonItem] animated:animated];
    self.isHelpShown = YES;
}

@end
