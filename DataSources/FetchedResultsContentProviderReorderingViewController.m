//
//  FetchedResultsContentProviderReorderingViewController.m
//  DataSources
//
//  Created by Petro Korienev on 2/18/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FetchedResultsContentProviderReorderingViewController.h"

@interface FetchedResultsContentProviderReorderingViewController ()

@end

@implementation FetchedResultsContentProviderReorderingViewController

- (void)closeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"backToRootViewControllerWithSegue" sender:sender];
}

@end
