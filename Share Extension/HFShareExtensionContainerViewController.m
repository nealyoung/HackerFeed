//
//  HFShareExtensionContainerViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 1/19/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFNewPostViewController.h"
#import "HFShareExtensionContainerViewController.h"
#import "HFNavigationBar.h"
#import "ShareViewController.h"

@interface HFShareExtensionContainerViewController ()

- (void)customizeAppearance;

@end

@implementation HFShareExtensionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeAppearance];
    
//    UINavigationController *shareNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class] toolbarClass:nil];
//    
//    HFNewPostViewController *newPostViewController = [[HFNewPostViewController alloc] initWithNibName:nil bundle:nil];
//    
//    ShareViewController *shareViewController = [[ShareViewController alloc] initWithNibName:nil bundle:nil];
//    shareNavigationController.viewControllers = @[newPostViewController];
    
    HFNewPostViewController *newPostViewController = [[HFNewPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *shareNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                 toolbarClass:nil];
    shareNavigationController.viewControllers = @[newPostViewController];
    
    shareNavigationController.view.frame = self.view.bounds;
    [self.view addSubview:shareNavigationController.view];
    [self addChildViewController:shareNavigationController];
    [shareNavigationController didMoveToParentViewController:self];
}

- (void)customizeAppearance {
    self.view.tintColor = [UIColor hf_themedAccentColor];

    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: self.view.tintColor,
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:19.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:[UIColor hf_themedNavigationBarColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSDictionary *barButtonItemTitleTextAttributes = @{NSForegroundColorAttributeName:self.view.tintColor,
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:18.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
}

@end
