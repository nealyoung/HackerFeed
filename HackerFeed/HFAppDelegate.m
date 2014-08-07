//
//  HFAppDelegate.m
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFAppDelegate.h"

#import "HNManager.h"
#import "HFDropdownMenuController.h"
#import "HFFilterPostDataSource.h"
#import "HFPostListViewController.h"
#import "HFPostViewController.h"
#import "HFUserProfileViewController.h"
#import "SVProgressHUD.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    HFPostListViewController *topStoriesViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    topStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeTop];
    topStoriesViewController.title = NSLocalizedString(@"Top Stories", nil);
    
    HFPostListViewController *newStoriesViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    newStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeNew];
    newStoriesViewController.title = NSLocalizedString(@"New Stories", nil);
    
    HFPostListViewController *askHNViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    askHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeAsk];
    askHNViewController.title = NSLocalizedString(@"Ask HN", nil);
    
    HFPostListViewController *showHNViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    showHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeShowHN];
    showHNViewController.title = NSLocalizedString(@"Show HN", nil);
    
    HFPostListViewController *jobsViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    jobsViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeJobs];
    jobsViewController.title = NSLocalizedString(@"Jobs", nil);
    
    HFUserProfileViewController *profileViewController = [[HFUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    profileViewController.showsLoggedInUser = YES;
    [profileViewController view];
    
    HFDropdownMenuController *dropdownMenuViewController = [[HFDropdownMenuController alloc] initWithDropdownViewControllers:@[topStoriesViewController,
                                                                                                                               newStoriesViewController,
                                                                                                                               askHNViewController,
                                                                                                                               showHNViewController,
                                                                                                                               jobsViewController,
                                                                                                                               profileViewController]];
    dropdownMenuViewController.dropdownMenu.itemFont = [UIFont semiboldApplicationFontOfSize:17.0f];
    
    UIView *navigationBarBorderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               CGRectGetMaxY(dropdownMenuViewController.navigationBar.frame),
                                                                               CGRectGetWidth(dropdownMenuViewController.navigationBar.frame),
                                                                               1.0f)];
    navigationBarBorderView.backgroundColor = [UIColor applicationColor];
    [dropdownMenuViewController.navigationBar addSubview:navigationBarBorderView];
    
    [[HNManager sharedManager] startSession];
    [self customizeAppearance];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        HFPostViewController *postViewController = [[HFPostViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:postViewController];
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        splitViewController.delegate = postViewController;
        splitViewController.viewControllers = @[dropdownMenuViewController, navigationController];
        
        self.window.rootViewController = splitViewController;
    } else {
        self.window.rootViewController = dropdownMenuViewController;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)customizeAppearance {
    self.window.tintColor = [UIColor applicationColor];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:self.window.tintColor,
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:19.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    NSDictionary *barButtonItemTitleTextAttributes = @{NSForegroundColorAttributeName:self.window.tintColor,
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:18.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
    
    [SVProgressHUD setFont:[UIFont applicationFontOfSize:15.0f]];
}

@end
