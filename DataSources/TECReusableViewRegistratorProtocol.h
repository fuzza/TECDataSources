//
//  TECCollectionViewCellRegistratorProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/19/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TECReusableViewRegistrationAdapterProtocol;

@protocol TECReusableViewRegistratorProtocol <NSObject>

@property (nonatomic, strong) id <TECReusableViewRegistrationAdapterProtocol> registrationAdapter;

- (NSString *)reuseIdentifierForItem:(id)item
                         atIndexPath:(NSIndexPath *)indexPath;

@end
