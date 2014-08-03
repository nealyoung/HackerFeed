//
//  HFDropdownMenuViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFDropdownMenu.h"

@interface HFDropdownMenuController : UINavigationController

@property (nonatomic, readonly) HFDropdownMenu *dropdownMenu;
@property (nonatomic) NSArray *dropdownViewControllers;
@property (nonatomic) UIViewController *selectedViewController;

- (instancetype)initWithDropdownViewControllers:(NSArray *)viewControllers;

@end
