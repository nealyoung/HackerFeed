#import "HFDropdownMenu.h"
#import "HFDropdownMenuButton.h"
#import "HFDropdownMenuListBackgroundView.h"

@interface HFDropdownMenu ()

@property (nonatomic) NSArray<HFDropdownMenuButton *> *buttons;
@property (nonatomic) HFDropdownMenuButton *selectedButton;
@property HFDropdownMenuListBackgroundView *listView;

- (void)applyTheme;
- (void)buttonPressed:(HFDropdownMenuButton *)sender;
- (void)setSelectedButton:(HFDropdownMenuButton *)selectedButton animated:(BOOL)animated;

@end

@implementation HFDropdownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationDuration = 0.54f;
        _itemHeight = 40.0f;
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.layer.opacity = 0.0f;
        _backgroundView.isAccessibilityElement = YES;
        _backgroundView.accessibilityLabel = NSLocalizedString(@"Dismiss", nil);
        _backgroundView.accessibilityHint = NSLocalizedString(@"Dismisses the feed type selection menu", nil);
        [self addSubview:_backgroundView];

        _listView = [[HFDropdownMenuListBackgroundView alloc] initWithFrame:CGRectZero];
        _listView.layer.opacity = 0.0f;
        _listView.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        _listView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
        [self addSubview:_listView];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [self initWithFrame:CGRectZero];
    
    if (self) {
        self.items = items;
    }
    
    return self;
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
}

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
    
    self.backgroundView.frame = self.bounds;

    CGFloat menuBackgroundHeight = 16.0f + self.itemHeight * [self.items count];
    self.listView.bounds = CGRectMake(0.0f,
                                      0.0f,
                                      CGRectGetWidth(self.frame) - 80.0f,
                                      menuBackgroundHeight);
    self.listView.center = CGPointMake(self.center.x, 54.0f);
}

- (CGFloat)navigationBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height + CGRectGetHeight(self.delegate.navigationBar.frame);
}

- (void)applyTheme {
    _backgroundView.backgroundColor = [UIColor blackColor];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // The dropdown menu view always appears over the content, so we don't pick up touches unless the menu is showing and we want to dismiss it
    if (self.showingMenu) {
        return YES;
    } else {
        return NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.showingMenu) {
        [self hideMenu];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)setButtons:(NSArray *)buttons {
    for (HFDropdownMenuButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    
    _buttons = buttons;
    [buttons enumerateObjectsUsingBlock:^(HFDropdownMenuButton *button, NSUInteger idx, BOOL *stop) {
        button.tag = idx;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }];

    self.listView.buttons = buttons;
    [self setNeedsLayout];
}

- (void)setSelectedItem:(HFDropdownMenuItem *)selectedItem {
    [self setSelectedItem:selectedItem animated:NO];
}

- (void)setSelectedItem:(HFDropdownMenuItem *)selectedItem animated:(BOOL)animated {
    _selectedItem = selectedItem;
    [self setSelectedButton:self.buttons[[self.items indexOfObject:selectedItem]] animated:animated];
}

- (void)setSelectedButton:(HFDropdownMenuButton *)selectedButton {
    [self setSelectedButton:selectedButton animated:NO];
}

- (void)setSelectedButton:(HFDropdownMenuButton *)selectedButton animated:(BOOL)animated {
    if (selectedButton != _selectedButton) {
        [_selectedButton setSelected:NO animated:animated];
        [selectedButton setSelected:YES animated:animated];

        _selectedButton = selectedButton;
    }
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    NSMutableArray *buttons = [NSMutableArray array];
    for (HFDropdownMenuItem *item in items) {
        HFDropdownMenuButton *button = [[HFDropdownMenuButton alloc] initWithItem:item];
        item.view = button;

        if (self.itemFont) {
            button.titleLabel.font = self.itemFont;
        }
        
        [buttons addObject:button];
    }
    
    self.buttons = [NSArray arrayWithArray:buttons];
}

- (void)setItemFont:(UIFont *)itemFont {
    _itemFont = itemFont;
    
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = itemFont;
    }
}

- (void)buttonPressed:(HFDropdownMenuButton *)sender {
    [self setSelectedButton:sender animated:YES];
    self.selectedItem = self.items[sender.tag];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self toggleMenu];

        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectItem:)]) {
            [self.delegate dropdownMenu:self didSelectItem:self.selectedItem];
        }
    });
}

- (void)toggleMenu {
    self.showingMenu ? [self hideMenu] : [self showMenu];
}

- (void)hideMenu {
    self.showingMenu = NO;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillHide:)]) {
        [self.delegate dropdownMenuWillHide:self];
    }
    
    [UIView animateWithDuration:self.animationDuration * 0.75f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.7f
                        options:0
                     animations:^{
                         self.backgroundView.layer.opacity = 0.0f;
                         self.listView.layer.opacity = 0.0f;

                         self.listView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
                     }
                     completion:^(BOOL finished) {
                         if ([self.delegate respondsToSelector:@selector(dropdownMenuDidHide:)]) {
                             [self.delegate dropdownMenuDidHide:self];
                         }
                     }];
}

- (void)showMenu {
    self.showingMenu = YES;
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        [self.delegate dropdownMenuWillShow:self];
    }
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0f
         usingSpringWithDamping:0.72f
          initialSpringVelocity:0.6f
                        options:0
                     animations:^{
                         self.backgroundView.layer.opacity = 0.16f;
                         self.listView.layer.opacity = 1.0f;

                         self.listView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
                             [self.delegate dropdownMenuDidShow:self];
                         }
                     }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
