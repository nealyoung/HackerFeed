#import "HFDropdownMenuNavigationController.h"

#import "HFDropdownMenuTitleView.h"

@interface HFDropdownMenuNavigationController () <HFDropdownMenuDelegate, UINavigationBarDelegate>

@property HFDropdownMenuTitleView *titleView;

@end

@implementation HFDropdownMenuNavigationController

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.dropdownMenu setNeedsLayout];
    [self.visibleViewController.view setNeedsLayout];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithDropdownViewControllers:(NSArray *)viewControllers {
    self = [super initWithRootViewController:[viewControllers firstObject]];
    
    if (self) {
        [self commonInit];
        
        NSMutableArray *items = [NSMutableArray array];
        
        for (UIViewController *viewController in viewControllers) {
            HFDropdownMenuItem *menuItem = [[HFDropdownMenuItem alloc] init];
            menuItem.title = viewController.title;
            [items addObject:menuItem];
        }
        
        self.dropdownViewControllers = viewControllers;
    }
    
    return self;
}

- (void)commonInit {
    _dropdownMenu = [[HFDropdownMenu alloc] initWithFrame:self.view.bounds];
    _dropdownMenu.delegate = self;
    [self.view addSubview:_dropdownMenu];

    self.titleView = [[HFDropdownMenuTitleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 28.0f)];
    [self.titleView addTarget:self.dropdownMenu action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

//    [self.view insertSubview:_dropdownMenu belowSubview:self.navigationBar];

    // iOS doesn't allow us to add constraints to a navigation bar managed by a UINavigationController
    //HFDropdownMenuTitleView *titleView = [[HFDropdownMenuTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 24)];
    //[[self.navigationBar.items firstObject] setTitleView:titleView];
    //titleView.center = self.navigationBar.center;
    //[self.navigationBar addSubview:titleView];
}

- (void)setDropdownViewControllers:(NSArray *)dropdownViewControllers {
    _dropdownViewControllers = dropdownViewControllers;

    NSMutableArray<HFDropdownMenuItem *> *mutableItems = [NSMutableArray array];

    for (UIViewController *viewController in dropdownViewControllers) {
        viewController.navigationItem.titleView = self.titleView;
        
        HFDropdownMenuItem *menuItem = viewController.dropdownMenuItem;
        menuItem.title = viewController.title;
        [mutableItems addObject:menuItem];
    }
    
    self.dropdownMenu.items = [NSArray arrayWithArray:mutableItems];
    self.selectedViewController = dropdownViewControllers.firstObject;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    _selectedViewController = selectedViewController;

    self.titleView.titleLabel.text = selectedViewController.title;
    self.dropdownMenu.selectedItem = self.dropdownMenu.items[[self.dropdownViewControllers indexOfObject:selectedViewController]];
    self.viewControllers = @[selectedViewController];
}

#pragma mark - HFDropdownMenuDelegate

- (void)dropdownMenu:(HFDropdownMenu *)dropdownMenu didSelectItem:(HFDropdownMenuItem *)menuItem {
    self.selectedViewController = self.dropdownViewControllers[[dropdownMenu.items indexOfObject:menuItem]];
    [self.titleView sizeToFit];
    
//    CGRect titleViewFrame = CGRectZero;
//    titleViewFrame.size = [self.titleView intrinsicContentSize];
//    self.titleView.frame = titleViewFrame;        
}

- (void)dropdownMenuWillHide:(HFDropdownMenu *)dropdownMenu {
    self.titleView.expanded = NO;
}

- (void)dropdownMenuWillShow:(HFDropdownMenu *)dropdownMenu {
    self.titleView.expanded = YES;
}

@end
