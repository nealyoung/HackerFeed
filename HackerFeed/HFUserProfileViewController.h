//
//  HFUserProfileViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFProfileViewController.h"

#import "HFBorderedButton.h"

@interface HFUserProfileViewController : HFProfileViewController

@property IBOutlet HFBorderedButton *loginButton;
@property IBOutlet UIBarButtonItem *logoutItem;

@end
