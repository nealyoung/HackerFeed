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

@protocol ORNLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(HFLoginViewController *)loginViewController didLoginWithUser:(HNUser *)user;

@end

@interface HFLoginViewController : UIViewController

@property (weak) id <ORNLoginViewControllerDelegate> delegate;

@property IBOutlet UITextField *usernameTextField;
@property IBOutlet UITextField *passwordTextField;
@property IBOutlet UILabel *securityLabel;
@property IBOutlet HFBorderedButton *submitButton;

@end
