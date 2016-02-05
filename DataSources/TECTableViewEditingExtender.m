//
//  TECTableViewEditingExtender.m
//  DataSources
//
//  Created by Petro Korienev on 2/3/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECTableViewEditingExtender.h"

TECTableViewExtenderInterfaceExtension(TECTableViewEditingExtender) {
    BOOL _isEditing;
}
@property (nonatomic, copy) TECTableViewEditingExtenderCanEditBlock canEditBlock;

TECTableViewExtenderEnd

TECTableViewExtenderImplementation(TECTableViewEditingExtender)

+ (instancetype)editingExtenderWithCanEditBlock:(TECTableViewEditingExtenderCanEditBlock)block {
    return [[self alloc] initWithCanEditBlock:block];
}

- (instancetype)initWithCanEditBlock:(TECTableViewEditingExtenderCanEditBlock)block {
    self = [self init];
    if (self) {
        self.canEditBlock = block;
    }
    return self;
}

- (void)setEditing:(BOOL)editing {
    [self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    _isEditing = editing;
    [self.tableView setEditing:editing animated:animated];
}

- (BOOL)isEditing {
    return _isEditing;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = _isEditing;
    if (result) {
        if (self.canEditBlock) {
            result = self.canEditBlock(tableView,
                                       indexPath,
                                       self.contentProvider[indexPath.section],
                                       self.contentProvider[indexPath]);
        }
    }
    return result;
}

TECTableViewExtenderEnd
