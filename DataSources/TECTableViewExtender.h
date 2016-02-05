//
//  TECBaseModule.h
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECContentProviderProtocol;
@protocol TECTableViewCellFactoryProtocol;

#define TECTableViewExtenderInterface(InterfaceName) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wprotocol\"") \
    @interface InterfaceName : TECTableViewExtender

#define TECTableViewExtenderInterfaceExtension(InterfaceName) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wprotocol\"") \
    @interface InterfaceName ()

#define TECTableViewExtenderImplementation(InterfaceName) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wprotocol\"") \
    @implementation InterfaceName

#define TECTableViewExtenderEnd @end \
    _Pragma("clang diagnostic pop") \

@interface TECTableViewExtender : NSObject <UITableViewDataSource, UITableViewDelegate>

+ (instancetype)extender;

@property (nonatomic, weak) id<TECContentProviderProtocol> contentProvider;
@property (nonatomic, weak) UITableView *tableView;

@end
