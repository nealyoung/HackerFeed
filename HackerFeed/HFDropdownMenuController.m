//
//  HFDropdownMenuViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFDropdownMenuController.h"

@interface HFDropdownMenuController () <HFDropdownMenuDelegate>

@end

@implementation HFDropdownMenuController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithDropdownViewControllers:(NSArray *)viewControllers {
    self = [super initWithRootViewController:[viewControllers firstObject]];
    
    if (self) {
        NSMutableArray *items = [NSMutableArray array];
        
        for (UIViewController *viewController in viewControllers) {
            HFDropdownMenuItem *menuItem = [[HFDropdownMenuItem alloc] init];
            menuItem.title = viewController.title;
            [items addObject:menuItem];
        }
        
        _dropdownMenu = [[HFDropdownMenu alloc] initWithItems:items];
        _dropdownMenu.delegate = self;
        [self.view insertSubview:_dropdownMenu belowSubview:self.navigationBar];
        
        self.dropdownViewControllers = viewControllers;
    }
    
    return self;
}

- (void)commonInit {
    _dropdownMenu = [[HFDropdownMenu alloc] initWithFrame:self.view.bounds];
    _dropdownMenu.delegate = self;
    [self.view insertSubview:_dropdownMenu belowSubview:self.navigationBar];
}

- (void)setDropdownViewControllers:(NSArray *)dropdownViewControllers {
    _dropdownViewControllers = dropdownViewControllers;
    NSMutableArray *items = [NSMutableArray array];
    
    for (UIViewController *viewController in dropdownViewControllers) {
        UIBarButtonItem *toggleBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ListIcon"]
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self.dropdownMenu
                                                                               action:@selector(toggleMenu)];
        viewController.navigationItem.leftBarButtonItem = toggleBarButtonItem;
        
        HFDropdownMenuItem *menuItem = [[HFDropdownMenuItem alloc] init];
        menuItem.title = viewController.title;
        [items addObject:menuItem];
    }
    
    self.dropdownMenu.items = items;
    
    self.viewControllers = @[[dropdownViewControllers firstObject]];
}

#pragma mark - ORNDropdownMenuDelegate

- (void)dropdownMenu:(HFDropdownMenu *)dropdownMenu didSelectItem:(HFDropdownMenuItem *)menuItem {
    UIViewController *selectedViewController = self.dropdownViewControllers[[dropdownMenu.items indexOfObject:menuItem]];
    self.viewControllers = @[selectedViewController];
    
    [self.dropdownMenu toggleMenu];
}

@end
