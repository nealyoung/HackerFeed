//
//  HFUserProfileViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFUserProfileViewController.h"

#import "HFLoginViewController.h"

@interface HFUserProfileViewController () <ORNLoginViewControllerDelegate>

@end

NSString * const kLoginViewControllerIdentifier = @"ORNLoginViewController";

@implementation HFUserProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    self.user = [HNManager sharedManager].SessionUser;
}

- (void)setUser:(HNUser *)user {
    [super setUser:user];
    
    if (user) {
        self.loginButton.hidden = YES;
        self.navigationItem.rightBarButtonItem = self.logoutItem;
    } else {
        self.loginButton.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    HFLoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                             bundle:nil] instantiateViewControllerWithIdentifier:kLoginViewControllerIdentifier];
    loginViewController.title = @"Login";
    loginViewController.delegate = self;
    
    UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [self presentViewController:loginNavigationController animated:YES completion:nil];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [[HNManager sharedManager] logout];
    self.user = nil;
}

#pragma mark - ORNLoginViewControllerDelegate

- (void)loginViewController:(HFLoginViewController *)loginViewController didLoginWithUser:(HNUser *)user {
    self.user = user;
}

@end
