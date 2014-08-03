//
//  HFProfileViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libHN.h"

@interface HFProfileViewController : UIViewController

@property IBOutlet UITableView *tableView;

@property BOOL showsLoggedInUser;
@property (nonatomic) HNUser *user;

@end
