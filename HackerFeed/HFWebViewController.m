//
//  HFWebViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 8/7/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFWebViewController.h"

@interface HFWebViewController ()

@end

@implementation HFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
}

- (void)doneButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
