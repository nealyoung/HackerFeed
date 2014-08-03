//
//  UIViewController+HFDropdownMenu.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFDropdownMenuController.h"

@interface UIViewController (HFDropdownMenu)

@property (nonatomic, readonly, strong) HFDropdownMenuController *dropdownMenuController;
@property (nonatomic, retain) HFDropdownMenuItem *dropdownMenuItem;

- (void)toggleDropdownMenu;
- (void)showDropdownMenu;
- (void)hideDropdownMenu;

@end
