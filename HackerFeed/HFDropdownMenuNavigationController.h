//
//  HFDropdownMenuViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import UIKit;

#import "HFDropdownMenu.h"

@interface HFDropdownMenuNavigationController : UINavigationController

@property (nonatomic, readonly) HFDropdownMenu *dropdownMenu;
@property (nonatomic) NSArray *dropdownViewControllers;
@property (nonatomic) UIViewController *selectedViewController;

- (instancetype)initWithDropdownViewControllers:(NSArray *)viewControllers;

@end
