//
//  HFLoginPopupController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFLoginPopupController.h"

#import "HFAlertViewController.h"
#import "HFLoginPopupView.h"
#import "HFModalPresentationManager.h"
#import "SVProgressHUD.h"

@interface HFLoginPopupController () <UITextFieldDelegate>

@property (nonatomic) HFLoginPopupView *loginView;
@property (nonatomic) HFModalPresentationManager *modalPresentationManager;

@end

@implementation HFLoginPopupController

- (HFModalPresentationManager *)modalPresentationManager {
    if (!_modalPresentationManager) {
        _modalPresentationManager = [[HFModalPresentationManager alloc] init];
    }
    
    return _modalPresentationManager;
}

- (void)showInViewController:(UIViewController *)viewController {
    HFAlertViewController *alertViewController = [[HFAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = NSLocalizedString(@"Log In", nil);
    alertViewController.message = self.message ? self.message : NSLocalizedString(@"You must be signed in to vote", nil);
    
    [alertViewController addAction:[HFAlertAction actionWithTitle:NSLocalizedString(@"Submit", nil) style:UIAlertActionStyleDefault handler:^(HFAlertAction *action) {
        [self.loginView endEditing:NO];
        
        [SVProgressHUD show];
        
        [[HNManager sharedManager] loginWithUsername:self.loginView.usernameTextField.text
                                            password:self.loginView.passwordTextField.text
                                          completion:^(HNUser *user) {
                                              if (user) {
                                                  [SVProgressHUD dismiss];
                                                  
                                                  if (self.loginCompletionBlock) {
                                                      self.loginCompletionBlock(user);
                                                  }
                                                  
                                                  [viewController dismissViewControllerAnimated:YES completion:nil];
                                              } else {
                                                  [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Incorrect username or password", nil)];
                                              }
                                          }];
    }]];
    
    [alertViewController addAction:[HFAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(HFAlertAction *action) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    alertViewController.modalPresentationStyle = UIModalPresentationCustom;
    alertViewController.transitioningDelegate = self.modalPresentationManager;
    
    self.loginView = [[HFLoginPopupView alloc] initWithFrame:CGRectZero];
    self.loginView.usernameTextField.delegate = self;
    self.loginView.passwordTextField.delegate = self;
    
    alertViewController.alertViewContentView = self.loginView;
    
    [viewController presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginView.usernameTextField) {
        [self.loginView.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
