//
//  UIViewController+HFDropdownMenu.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFDropdownMenuNavigationController.h"

@interface UIViewController (HFDropdownMenu)

@property (nonatomic, readonly, strong) HFDropdownMenuNavigationController *dropdownMenuController;
@property (nonatomic, retain) HFDropdownMenuItem *dropdownMenuItem;

- (void)toggleDropdownMenu;
- (void)showDropdownMenu;
- (void)hideDropdownMenu;

@end
