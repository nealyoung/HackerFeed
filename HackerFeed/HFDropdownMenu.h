@import UIKit;

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

@property UIView *backgroundView;

/**
 Items displayed in the dropdown menu
 */
@property (nonatomic) NSArray *items;

/**
 The currently selected item
 */
@property (nonatomic) HFDropdownMenuItem *selectedItem;

/**
 Whether the dropdown menu is being displayed or is hidden
 */
@property (nonatomic) BOOL showingMenu;

/**
 Length of the menu's show/hide animation
 */
@property (nonatomic) CGFloat animationDuration;

/**
 Height of each item in the menu
 */
@property (nonatomic) CGFloat itemHeight;

/**
 Font used in the display of buttons
 */
@property (nonatomic) UIFont *itemFont;

@property (nonatomic) UINavigationController <HFDropdownMenuDelegate> *delegate;

- (instancetype)initWithItems:(NSArray *)items;

- (void)toggleMenu;
- (void)showMenu;
- (void)hideMenu;

@end
