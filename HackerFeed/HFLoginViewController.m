//
//  HFLoginViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/22/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFLoginViewController.h"

#import "SVProgressHUD.h"

@interface HFLoginViewController () <UITextFieldDelegate>

@end

@implementation HFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameTextField.font = [UIFont applicationFontOfSize:16.0f];
    self.passwordTextField.font = [UIFont applicationFontOfSize:16.0f];
    self.securityLabel.font = [UIFont smallCapsLightApplicationFontWithSize:14.0f];
    
    [self.usernameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonPressed:(id)sender {
    [SVProgressHUD show];
    
    [[HNManager sharedManager] loginWithUsername:self.usernameTextField.text
                                        password:self.passwordTextField.text
                                      completion:^(HNUser *user) {
                                          if (user) {
                                              [SVProgressHUD dismiss];
                                              [self.delegate loginViewController:self didLoginWithUser:user];
                                              [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                          } else {
                                              [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Incorrect username or password", nil)];
                                          }
                                      }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
    
    return YES;
}

@end
