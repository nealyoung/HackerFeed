//
//  HFDropdownMenu.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HFDropdownMenuItem.h"

@class HFDropdownMenu;

@protocol HFDropdownMenuDelegate <NSObject>

- (void)dropdownMenu:(HFDropdownMenu *)dropdownMenu didSelectItem:(HFDropdownMenuItem *)menuItem;

@optional

- (void)dropdownMenuWillShow:(HFDropdownMenu *)dropdownMenu;
- (void)dropdownMenuDidShow:(HFDropdownMenu *)dropdownMenu;

- (void)dropdownMenuWillHide:(HFDropdownMenu *)dropdownMenu;
- (void)dropdownMenuDidHide:(HFDropdownMenu *)dropdownMenu;

@end


@interface HFDropdownMenu : UIView

@property UIVisualEffectView *backgroundView;

@property (nonatomic) NSArray *items;
@property (nonatomic) HFDropdownMenuItem *selectedItem;
@property (nonatomic) BOOL showingMenu;

@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) UIFont *itemFont;

@property (nonatomic) UINavigationController <HFDropdownMenuDelegate> *delegate;

- (instancetype)initWithItems:(NSArray *)items;

- (void)toggleMenu;
- (void)showMenu;
- (void)hideMenu;

@end
