//
//  TECContentProviderDelegate.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECContentProviderProtocol;
@protocol TECSectionModelProtocol;

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
                         atIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(TECContentProviderItemChangeType)changeType
                        newIndexPath:(NSIndexPath *)newIndexPath;
- (void)contentProviderDidChangeContent:(id<TECContentProviderProtocol>)contentProvider;

@end
