//
//  HFShareExtensionNavigationController.m
//  HackerFeed
//
//  Created by Nealon Young on 12/28/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFShareExtensionNavigationController.h"
#import "ShareViewController.h"

@interface HFShareExtensionNavigationController ()

@end

@implementation HFShareExtensionNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ShareViewController *shareViewController = [[ShareViewController alloc] initWithNibName:nil bundle:nil];
    self.viewControllers = @[shareViewController];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
