//
//  HFUserProfileViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFUserProfileViewController.h"

#import "HFLoginViewController.h"

@interface HFUserProfileViewController () <HFLoginViewControllerDelegate>

@end

NSString * const kLoginViewControllerIdentifier = @"ORNLoginViewController";

@implementation HFUserProfileViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

        self.loginButton = [HFBorderedButton buttonWithType:UIButtonTypeCustom];
        [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.loginButton setTitle:NSLocalizedString(@"login to hacker news", nil) forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginButton];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:180.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0f
                                                               constant:54.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                               constant:0.0f]];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [HNManager sharedManager].SessionUser;
}

- (void)setUser:(HNUser *)user {
    [super setUser:user];
    
    if (user) {
        self.loginButton.hidden = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logoutButtonPressed:)];
    } else {
        self.loginButton.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)loginButtonPressed:(id)sender {
    HFLoginViewController *loginViewController = [[HFLoginViewController alloc] initWithNibName:nil bundle:nil];
    loginViewController.title = @"Login";
    loginViewController.delegate = self;
    
    UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        loginNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:loginNavigationController animated:YES completion:nil];
}

- (void)logoutButtonPressed:(id)sender {
    [[HNManager sharedManager] logout];
    self.user = nil;
}

#pragma mark - HFLoginViewControllerDelegate

- (void)loginViewController:(HFLoginViewController *)loginViewController didLoginWithUser:(HNUser *)user {
    self.user = user;
}

@end
