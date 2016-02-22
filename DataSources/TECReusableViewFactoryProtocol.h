//
//  TECReusableViewFactoryProtocol.h
//  DataSources
//
//  Created by Alexey Fayzullov on 2/22/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TECReusableViewFactoryProtocol <NSObject>

- (UIView *)viewForItem:(id)item
            atIndexPath:(NSIndexPath *)indexPath;

- (void)configureView:(UIView *)view
              forItem:(id)item
          atIndexPath:(NSIndexPath *)indexPath;

@end
