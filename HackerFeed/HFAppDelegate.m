//
//  HFAppDelegate.m
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFAppDelegate.h"

#import "HNManager.h"
#import "HFDropdownMenuNavigationController.h"
#import "HFFilterPostDataSource.h"
#import "HFNavigationBar.h"
#import "HFPostListViewController.h"
#import "HFPostViewController.h"
#import "HFSettingsViewController.h"
#import "HFToolbar.h"
#import "SVProgressHUD.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HFPostListViewController *topStoriesViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    topStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeTop image:[UIImage imageNamed:@"TopStoriesIcon"]];
    topStoriesViewController.title = NSLocalizedString(@"Top Stories", nil);
    
    HFPostListViewController *newStoriesViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    newStoriesViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeNew image:[UIImage imageNamed:@"NewStoriesIcon"]];
    newStoriesViewController.title = NSLocalizedString(@"New Stories", nil);
    
    HFPostListViewController *askHNViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    askHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeAsk image:[UIImage imageNamed:@"AskHNIcon"]];
    askHNViewController.title = NSLocalizedString(@"Ask HN", nil);
    
    HFPostListViewController *showHNViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    showHNViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeShowHN image:[UIImage imageNamed:@"ShowHNIcon"]];
    showHNViewController.title = NSLocalizedString(@"Show HN", nil);
    
    HFPostListViewController *jobsViewController = [[HFPostListViewController alloc] initWithNibName:nil bundle:nil];
    jobsViewController.dataSource = [[HFFilterPostDataSource alloc] initWithPostFilterType:PostFilterTypeJobs image:[UIImage imageNamed:@"JobsIcon"]];
    jobsViewController.title = NSLocalizedString(@"Jobs", nil);
    
    HFSettingsViewController *settingsViewController = [[HFSettingsViewController alloc] initWithNibName:nil bundle:nil];
    
    HFDropdownMenuNavigationController *dropdownMenuViewController = [[HFDropdownMenuNavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                                               toolbarClass:[HFToolbar class]];
    dropdownMenuViewController.dropdownViewControllers = @[topStoriesViewController,
                                                           newStoriesViewController,
                                                           askHNViewController,
                                                           showHNViewController,
                                                           jobsViewController,
                                                           settingsViewController];
    dropdownMenuViewController.dropdownMenu.itemFont = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
    
    [[HNManager sharedManager] startSession];
//    [self customizeAppearance];
    [HFInterfaceTheme setupAppearanceForActiveTheme];
    NSLog(@"%@", self.window);
    
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
    
    [HFInterfaceTheme setupAppearanceForActiveTheme];
    [self setupKeyboardFrameChangeNotificationHandler];
    
    return YES;
}

- (void)applicationWillResignActive:(nonnull UIApplication *)application {
    NSLog(@"Resigning active application");
}

- (void)setupKeyboardFrameChangeNotificationHandler {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      CGRect keyboardFrame = [self.window convertRect:[(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                                                                             fromView:nil];
                                                      CGRect viewFrame = self.window.frame;
                                                      
                                                      viewFrame.size.height = CGRectGetMinY(keyboardFrame);
                                                      
                                                      UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
                                                      NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                                                      
                                                      // There is no animationDuration key when the user shows/hides the suggestions bar under iOS 8
                                                      if (animationDuration == 0.0f) {
                                                          animationDuration = 0.25f;
                                                      }
                                                      
                                                      [UIView animateWithDuration:animationDuration
                                                                            delay:0
                                                                          options:UIViewAnimationOptionBeginFromCurrentState | curve
                                                                       animations:^{
                                                                           self.window.frame = viewFrame;
                                                                       }
                                                                       completion:nil];
                                                  }];
}

- (void)customizeAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:[HFInterfaceTheme activeTheme].statusBarStyle];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont applicationFontOfSize:15.0f]];
    
    self.window.tintColor = [[HFInterfaceTheme activeTheme] accentColor];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:self.window.tintColor,
                                                       NSFontAttributeName: [UIFont systemFontOfSize:19.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:[[HFInterfaceTheme activeTheme] navigationBarColor]];
    [[UINavigationBar appearance] setTranslucent:NO];

    [[UIToolbar appearance] setBarTintColor:[[HFInterfaceTheme activeTheme] navigationBarColor]];
    [[UIToolbar appearance] setTranslucent:NO];
    
    NSDictionary *barButtonItemTitleTextAttributes = @{NSForegroundColorAttributeName:self.window.tintColor,
                                                       NSFontAttributeName: [UIFont systemFontOfSize:18.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
    
    [SVProgressHUD setFont:[UIFont applicationFontOfSize:15.0f]];
}

@end
