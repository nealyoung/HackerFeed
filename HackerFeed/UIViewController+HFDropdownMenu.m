//
//  UIViewController+HFDropdownMenu.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "UIViewController+HFDropdownMenu.h"

#import <objc/runtime.h>

static void *DropdownMenuItemPropertyKey = &DropdownMenuItemPropertyKey;

@implementation UIViewController (HFDropdownMenu)

- (HFDropdownMenuNavigationController *)dropdownMenuController {
    UIViewController *viewController = self.parentViewController;
    
    while (viewController) {
        if ([viewController isKindOfClass:[HFDropdownMenuNavigationController class]]) {
            return (HFDropdownMenuNavigationController *)viewController;
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

- (void)setDropdownMenuItem:(HFDropdownMenuItem *)dropdownMenuItem {
    objc_setAssociatedObject(self, DropdownMenuItemPropertyKey, dropdownMenuItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableArray *controllerItems = [self.dropdownMenuController.dropdownMenu.items mutableCopy];
    NSInteger index = [controllerItems indexOfObjectIdenticalTo:self.dropdownMenuItem];
    controllerItems[index] = dropdownMenuItem;
    
    self.dropdownMenuController.dropdownMenu.items = controllerItems;
}

- (HFDropdownMenuItem *)dropdownMenuItem {
    HFDropdownMenuItem *item = objc_getAssociatedObject(self, DropdownMenuItemPropertyKey);
    
    if (!item) {
        item = [[HFDropdownMenuItem alloc] init];
        item.title = self.title;
        
        self.dropdownMenuItem = item;
    }
    
    return item;
}

@end
