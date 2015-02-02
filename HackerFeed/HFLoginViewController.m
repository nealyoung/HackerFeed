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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.view.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.03f];
        
        self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [self.usernameTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.usernameTextField.returnKeyType = UIReturnKeyNext;
        self.usernameTextField.font = [UIFont applicationFontOfSize:14.0f];
        self.usernameTextField.placeholder = NSLocalizedString(@"Username", nil);
        self.usernameTextField.delegate = self;
        [self.view addSubview:self.usernameTextField];
        
        self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [self.passwordTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordTextField.returnKeyType = UIReturnKeyDone;
        self.passwordTextField.font = [UIFont applicationFontOfSize:14.0f];
        self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.delegate = self;
        [self.view addSubview:self.passwordTextField];
        
        self.securityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.securityLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.securityLabel.font = [UIFont smallCapsLightApplicationFontWithSize:15.0f];
        self.securityLabel.textAlignment = NSTextAlignmentCenter;
        self.securityLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
        self.securityLabel.text = NSLocalizedString(@"Your information is sent securely", nil);
        [self.view addSubview:self.securityLabel];
        
        self.submitButton = [HFBorderedButton buttonWithType:UIButtonTypeCustom];
        [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.submitButton setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.submitButton];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_usernameTextField]-15-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_usernameTextField)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_passwordTextField]-15-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_passwordTextField)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_securityLabel]-15-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_securityLabel)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-100-[_submitButton]-100-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_submitButton)]];
        
        id<UILayoutSupport> topGuide = self.topLayoutGuide;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-15-[_usernameTextField(34)]-8-[_passwordTextField(34)]-8-[_securityLabel]-8-[_submitButton(40)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(topGuide,
                                                                                                                 _usernameTextField,
                                                                                                                 _passwordTextField,
                                                                                                                 _securityLabel,
                                                                                                                 _submitButton)]];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.usernameTextField becomeFirstResponder];
}

- (void)submitButtonPressed:(id)sender {
    [SVProgressHUD show];
    
    [[HNManager sharedManager] loginWithUsername:self.usernameTextField.text
                                        password:self.passwordTextField.text
                                      completion:^(HNUser *user) {
                                          if (user) {
                                              [SVProgressHUD dismiss];
                                              
                                              if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewController:didLoginWithUser:)]) {
                                                  [self.delegate loginViewController:self didLoginWithUser:user];
                                              }
                                              
                                              [self.navigationController popViewControllerAnimated:YES];
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
