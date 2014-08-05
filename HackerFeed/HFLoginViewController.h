//
//  HFLoginViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/22/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libHN.h"
#import "HFBorderedButton.h"

@class HFLoginViewController;

@protocol HFLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(HFLoginViewController *)loginViewController didLoginWithUser:(HNUser *)user;

@end

@interface HFLoginViewController : UIViewController

@property (weak) id <HFLoginViewControllerDelegate> delegate;

@property UITextField *usernameTextField;
@property UITextField *passwordTextField;
@property UILabel *securityLabel;
@property HFBorderedButton *submitButton;

@end
