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
#import "HFUserProfileViewController.h"
#import "SVProgressHUD.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    HFPostListViewController *topStoriesViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                     bundle:nil] instantiateViewControllerWithIdentifier:@"PostListViewController"];
    topStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeTop];
    topStoriesViewController.title = NSLocalizedString(@"Top Stories", nil);
    
    HFPostListViewController *newStoriesViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                     bundle:nil] instantiateViewControllerWithIdentifier:@"PostListViewController"];
    newStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeNew];
    newStoriesViewController.title = NSLocalizedString(@"New Stories", nil);
    
    HFPostListViewController *askHNViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                bundle:nil] instantiateViewControllerWithIdentifier:@"PostListViewController"];
    askHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeAsk];
    askHNViewController.title = NSLocalizedString(@"Ask HN", nil);
    
    HFPostListViewController *showHNViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                 bundle:nil] instantiateViewControllerWithIdentifier:@"PostListViewController"];
    showHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeShowHN];
    showHNViewController.title = NSLocalizedString(@"Show HN", nil);
    
    HFPostListViewController *jobsViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                bundle:nil] instantiateViewControllerWithIdentifier:@"PostListViewController"];
    jobsViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeJobs];
    jobsViewController.title = NSLocalizedString(@"Jobs", nil);
    
    HFUserProfileViewController *profileViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                 bundle:nil] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    profileViewController.showsLoggedInUser = YES;
    [profileViewController view];
    
    HFDropdownMenuController *dropdownMenuViewController = [[HFDropdownMenuController alloc] initWithDropdownViewControllers:@[topStoriesViewController,
                                                                                                                                 newStoriesViewController,
                                                                                                                                 askHNViewController,
                                                                                                                                 showHNViewController,
                                                                                                                                 jobsViewController,
                                                                                                                                 profileViewController]];
    dropdownMenuViewController.dropdownMenu.itemFont = [UIFont semiboldApplicationFontOfSize:17.0f];
    
    self.window.rootViewController = dropdownMenuViewController;
    
    UIView *navigationBarBorderView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               CGRectGetMaxY(dropdownMenuViewController.navigationBar.frame),
                                                                               CGRectGetWidth(dropdownMenuViewController.navigationBar.frame),
                                                                               1.0f)];
    navigationBarBorderView.backgroundColor = [UIColor applicationColor];
    [dropdownMenuViewController.navigationBar addSubview:navigationBarBorderView];
    
    [[HNManager sharedManager] startSession];
    NSLog(@"%d", [[HNManager sharedManager] userIsLoggedIn]);
    
    [self customizeAppearance];
    return YES;
}

- (void)customizeAppearance {
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

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
