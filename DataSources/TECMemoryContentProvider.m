//
//  TECMemoryContentProvider.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECMemoryContentProvider.h"
#import "TECContentProviderDelegate.h"

@interface TECMemoryContentProvider ()

@property (nonatomic, strong) NSArray<id<TECSectionModelProtocol>> *sections;

@end

@implementation TECMemoryContentProvider
@synthesize presentationAdapter = _presentationAdapter;

- (instancetype)initWithSections:(NSArray<id<TECSectionModelProtocol>> *)sections {
    self = [super init];
    if(self) {
        self.sections = sections;
    }
    return self;
}

#pragma mark - TECContentProviderProtocol implementation

- (NSInteger)numberOfSections {
    return self.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.sections[section].count;
}

- (id<TECSectionModelProtocol>)sectionAtIndex:(NSInteger)index {
    return self.sections[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    id<TECSectionModelProtocol> section = self.sections[indexPath.section];
    return section[indexPath.row];
}

- (void)reloadDataSourceWithCompletion:(TECContentProviderCompletionBlock)completion {
    [self.presentationAdapter contentProviderDidReloadData:self];
    if(completion) {
        completion();
    }
}

@end
