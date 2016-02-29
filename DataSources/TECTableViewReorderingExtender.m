//
//  TECTableViewReorderingExtender.m
//  DataSources
//
//  Created by Petro Korienev on 2/4/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewReorderingExtender.h"
#import "TECContentProviderProtocol.h"

TECTableViewExtenderInterfaceExtension(TECTableViewReorderingExtender)

@property (nonatomic, copy) TECTableViewReorderingExtenderCanMoveBlock canMoveBlock;
@property (nonatomic, copy) TECTableViewReorderingExtenderTargetIndexPathBlock targetIndexPathBlock;

TECTableViewExtenderEnd

TECTableViewExtenderImplementation(TECTableViewReorderingExtender)

+ (instancetype)reorderingExtenderWithCanMoveBlock:(TECTableViewReorderingExtenderCanMoveBlock)canMoveBlock
                              targetIndexPathBlock:(TECTableViewReorderingExtenderTargetIndexPathBlock)targetIndexPathBlock {
    return [[self alloc] initWithCanMoveBlock:canMoveBlock
                         targetIndexPathBlock:targetIndexPathBlock];
}

- (instancetype)initWithCanMoveBlock:(TECTableViewReorderingExtenderCanMoveBlock)canMoveBlock
                targetIndexPathBlock:(TECTableViewReorderingExtenderTargetIndexPathBlock)targetIndexPathBlock {
    self = [self init];
    if (self) {
        self.canMoveBlock = canMoveBlock;
        self.targetIndexPathBlock = targetIndexPathBlock;
    }
    return self;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSIndexPath *result = proposedDestinationIndexPath;
    if (self.targetIndexPathBlock) {
        id targetItem = nil;
        // The item may be targeted to append existing section and will fire NSRangeException
        // without following check
        if (proposedDestinationIndexPath.row < [self.contentProvider[proposedDestinationIndexPath.section] count]) {
            targetItem = self.contentProvider[proposedDestinationIndexPath];
        }
        result = self.targetIndexPathBlock(tableView,
                                           sourceIndexPath,
                                           self.contentProvider[sourceIndexPath.section],
                                           self.contentProvider[sourceIndexPath],
                                           proposedDestinationIndexPath,
                                           self.contentProvider[proposedDestinationIndexPath.section],
                                           targetItem);
    }
    return result;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = YES;
    if (self.canMoveBlock) {
        result = self.canMoveBlock(tableView,
                                   indexPath,
                                   self.contentProvider[indexPath.section],
                                   self.contentProvider[indexPath]);
    }
    return result;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (![sourceIndexPath isEqual:destinationIndexPath]) {
        [self.contentProvider moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

TECTableViewExtenderEnd
