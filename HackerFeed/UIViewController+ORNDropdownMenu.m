//
//  UIViewController+HFDropdownMenu.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "UIViewController+ORNDropdownMenu.h"

#import <objc/runtime.h>

static void *dropdownMenuPropertyKey = &dropdownMenuPropertyKey;

@implementation UIViewController (HFDropdownMenu)

//- (void)addDropdownMenu:(ORNDropdownMenu *)dropdownMenu {
//    self.dropdownMenu = dropdownMenu;
//    
//    [self.view insertSubview:self.dropdownMenu belowSubview:self.navigationController.navigationBar];
//}

- (HFDropdownMenuController *)dropdownMenuController {
    UIViewController *viewController = self.parentViewController;
    
    while (viewController) {
        if ([viewController isKindOfClass:[HFDropdownMenuController class]]) {
            return (HFDropdownMenuController *)viewController;
        } else if (viewController.parentViewController && viewController.parentViewController != viewController) {
            viewController = viewController.parentViewController;
        } else {
            viewController = nil;
        }
    }
    
    return nil;
}

- (void)toggleDropdownMenu {
    CGPointEqualToPoint(self.dropdownMenuController.dropdownMenu.frame.origin, self.view.bounds.origin) ? [self hideDropdownMenu] : [self showDropdownMenu];
}

- (void)showDropdownMenu {
    if (!self.dropdownMenuController) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect dropdownMenuFrame = self.dropdownMenuController.dropdownMenu.frame;
        dropdownMenuFrame.origin = CGPointMake(0, 0);
        self.dropdownMenuController.dropdownMenu.frame = dropdownMenuFrame;
    }];
}

- (void)hideDropdownMenu {
    if (!self.dropdownMenuController) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect dropdownMenuFrame = self.dropdownMenuController.dropdownMenu.frame;
        dropdownMenuFrame.origin = CGPointMake(0, -CGRectGetHeight(self.dropdownMenuController.dropdownMenu.frame));
        self.dropdownMenuController.dropdownMenu.frame = dropdownMenuFrame;
    }];
}

@end
