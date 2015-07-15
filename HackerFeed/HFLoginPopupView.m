//
//  HFLoginPopupView.m
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFLoginPopupView.h"

#import "HFTextField.h"

@implementation HFLoginPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _usernameTextField = [[HFTextField alloc] initWithFrame:CGRectZero];
        [self.usernameTextField setTranslatesAutoresizingMaskIntoConstraints:NO];

        self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.usernameTextField.returnKeyType = UIReturnKeyNext;
        self.usernameTextField.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
        self.usernameTextField.font = [UIFont semiboldApplicationFontOfSize:14.0f];
        self.usernameTextField.placeholder = NSLocalizedString(@"Username", nil);
        [self addSubview:self.usernameTextField];
        
        _passwordTextField = [[HFTextField alloc] initWithFrame:CGRectZero];
        [self.passwordTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.passwordTextField.returnKeyType = UIReturnKeyDone;
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
        self.passwordTextField.font = [UIFont semiboldApplicationFontOfSize:14.0f];
        self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
        [self addSubview:self.passwordTextField];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_usernameTextField]-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_usernameTextField)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_passwordTextField]-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_passwordTextField)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_usernameTextField(28)]-12-[_passwordTextField(28)]-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:NSDictionaryOfVariableBindings(_usernameTextField, _passwordTextField)]];
    }
    
    return self;
}

@end
