//
//  TECContentProviderDelegate.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECContentProviderProtocol;

typedef NS_ENUM(NSUInteger, TECContentProviderSectionChangeType) {
    TECContentProviderSectionChangeTypeInsert,
    TECContentProviderSectionChangeTypeDelete
};

typedef NS_ENUM(NSUInteger, TECContentProviderItemChangeType) {
    TECContentProviderItemChangeTypeInsert,
    TECContentProviderItemChangeTypeDelete,
    TECContentProviderItemChangeTypeUpdate,
    TECContentProviderItemChangeTypeMove
};

@protocol TECContentProviderPresentationAdapterProtocol <NSObject>

@optional

- (void)contentProviderDidReloadData:(id <TECContentProviderProtocol>)contentProvider;

- (void)contentProviderWillChangeContent:(id<TECContentProviderProtocol>)contentProvider;
- (void)contentProviderDidChangeSection:(id<TECSectionModelProtocol>)section
                                atIndex:(NSUInteger)index
                          forChangeType:(TECContentProviderSectionChangeType)changeType;
- (void)contentProviderDidChangeItem:(id<TECSectionModelProtocol>)section
                         atIndexPath:(NSIndexPath *)index
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)index;
- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider;

@end
