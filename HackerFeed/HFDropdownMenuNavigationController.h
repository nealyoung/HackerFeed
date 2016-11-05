@import UIKit;

#import "HFDropdownMenu.h"

@interface HFDropdownMenuNavigationController : UINavigationController

@property (nonatomic, readonly) HFDropdownMenu *dropdownMenu;
@property (nonatomic) NSArray *dropdownViewControllers;
@property (nonatomic) UIViewController *selectedViewController;

- (instancetype)initWithDropdownViewControllers:(NSArray *)viewControllers;

@end
