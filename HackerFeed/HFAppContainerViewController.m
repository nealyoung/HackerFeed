#import "HFAppContainerViewController.h"

@interface HFAppContainerView : UIView

@property (nonatomic) UIView *childView;

@end

@implementation HFAppContainerView

- (void)setChildView:(UIView *)childView {
    _childView = childView;
    [self addSubview:childView];

    childView.layer.cornerRadius = 8.0f;
    childView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    self.childView.frame = CGRectMake(0.0f, 20.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 20.0f);
}

@end

@implementation HFAppContainerViewController

- (void)loadView {
    self.view = [[HFAppContainerView alloc] init];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setChildViewController:(UIViewController *)childViewController {
    if (self.childViewController) {
        [self.childViewController willMoveToParentViewController:nil];
        [self.childViewController.view removeFromSuperview];
    }

    _childViewController = childViewController;

    [childViewController willMoveToParentViewController:self];
    [self addChildViewController:childViewController];
    HFAppContainerView *containerView = (HFAppContainerView *)self.view;
    containerView.childView = childViewController.view;
    [childViewController didMoveToParentViewController:self];
}

@end
