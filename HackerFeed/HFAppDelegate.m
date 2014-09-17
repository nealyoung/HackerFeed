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
#import "HFNavigationBar.h"
#import "HFPostListViewController.h"
#import "HFPostViewController.h"
#import "HFUserProfileViewController.h"
#import "SVProgressHUD.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    HFPostListViewController *topStoriesViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    topStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:HNPostFilterTypeTop];
    topStoriesViewController.title = NSLocalizedString(@"Top Stories", nil);
    
    HFPostListViewController *newStoriesViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    newStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:HNPostFilterTypeNew];
    newStoriesViewController.title = NSLocalizedString(@"New Stories", nil);
    
    HFPostListViewController *askHNViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    askHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:HNPostFilterTypeAsk];
    askHNViewController.title = NSLocalizedString(@"Ask HN", nil);
    
    HFPostListViewController *showHNViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    showHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:HNPostFilterTypeShowHN];
    showHNViewController.title = NSLocalizedString(@"Show HN", nil);
    
    HFPostListViewController *jobsViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    jobsViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:HNPostFilterTypeJobs];
    jobsViewController.title = NSLocalizedString(@"Jobs", nil);
    
    HFUserProfileViewController *profileViewController = [[HFUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    profileViewController.showsLoggedInUser = YES;
    [profileViewController view];
    
    HFDropdownMenuController *dropdownMenuViewController = [[HFDropdownMenuController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                           toolbarClass:nil];
    dropdownMenuViewController.dropdownViewControllers = @[topStoriesViewController,
                                                           newStoriesViewController,
                                                           askHNViewController,
                                                           showHNViewController,
                                                           jobsViewController,
                                                           profileViewController];
    dropdownMenuViewController.dropdownMenu.itemFont = [UIFont semiboldApplicationFontOfSize:17.0f];
    
    [[HNManager sharedManager] startSession];
    [self customizeAppearance];
    
    HFPostViewController *postViewController = [[HFPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                 toolbarClass:nil];
    navigationController.viewControllers = @[postViewController];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    splitViewController.delegate = postViewController;
    splitViewController.viewControllers = @[dropdownMenuViewController, navigationController];
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.window.rootViewController = splitViewController;

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
