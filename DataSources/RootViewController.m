//
//  RootViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "RootViewController.h"

#import "CoreDataManager.h"

@interface RootViewController ()

- (IBAction)backToRootViewControllerWithSegue:(UIStoryboardSegue *)segue;

@end

@implementation RootViewController

- (void)backToRootViewControllerWithSegue:(UIStoryboardSegue *)segue {
    
}

- (void)cleanCoreData {
    [[CoreDataManager sharedObject] cleanup];
    [[CoreDataManager sharedObject] setup];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath].tag == 1) {
        [self cleanCoreData];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
