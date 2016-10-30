#import "HFDropdownMenu.h"

#import "HFDropdownMenuButton.h"

@interface HFDropdownMenu ()

@property (nonatomic) NSArray *buttons;
@property (nonatomic) HFDropdownMenuButton *selectedButton;
@property UIView *listView;

- (void)applyTheme;
- (void)buttonPressed:(HFDropdownMenuButton *)sender;
- (void)setSelectedButton:(HFDropdownMenuButton *)selectedButton animated:(BOOL)animated;

@end

const CGFloat kListTopMarginHeight = 80.0f;

@implementation HFDropdownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationDuration = 0.6f;
        _itemHeight = 40.0f;
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.layer.opacity = 0.0f;
        _backgroundView.isAccessibilityElement = YES;
        _backgroundView.accessibilityLabel = NSLocalizedString(@"Dismiss", nil);
        _backgroundView.accessibilityHint = NSLocalizedString(@"Dismisses the feed type selection menu", nil);
        [self addSubview:_backgroundView];

        _listView = [[UIView alloc] initWithFrame:CGRectZero];
        _listView.layer.shadowColor = [UIColor blackColor].CGColor;
        _listView.layer.shadowOpacity = 0.64f;
        _listView.layer.shadowOffset = CGSizeZero;
        _listView.layer.shadowRadius = 16.0f;
        _listView.layer.shouldRasterize = YES;
        _listView.layer.rasterizationScale = [UIScreen mainScreen].scale;

        _listView.layer.cornerRadius = 12.0f;
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

- (void)layoutSubviews {
    self.frame = self.superview.bounds;
    
    self.backgroundView.frame = self.bounds;
    
    CGFloat menuBackgroundHeight = kListTopMarginHeight + [self navigationBarHeight] + self.itemHeight * [self.items count];
    self.listView.frame = CGRectMake(40.0f,
                                     self.showingMenu ? -kListTopMarginHeight : -(menuBackgroundHeight + kListTopMarginHeight),
                                     CGRectGetWidth(self.frame) - 80.0f,
                                     menuBackgroundHeight);

    self.listView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.listView.bounds cornerRadius:self.listView.layer.cornerRadius].CGPath;

    [self.buttons enumerateObjectsUsingBlock:^(HFDropdownMenuButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(0.0f,
                                  kListTopMarginHeight + [self navigationBarHeight] + self.itemHeight * idx,
                                  CGRectGetWidth(self.listView.frame),
                                  self.itemHeight);
    }];
}

- (CGFloat)navigationBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height + CGRectGetHeight(self.delegate.navigationBar.frame);
}

- (void)applyTheme {
    _backgroundView.backgroundColor = [UIColor blackColor];
    _listView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
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
    
    [self.buttons enumerateObjectsUsingBlock:^(HFDropdownMenuButton *button, NSUInteger idx, BOOL *stop) {
        button.tag = idx;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.listView addSubview:button];
    }];
    
    [self setNeedsLayout];
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
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.6f
                        options:0
                     animations:^{
                         self.backgroundView.layer.opacity = 0.0f;

                         CGRect listFrame = self.listView.frame;
                         listFrame.origin = CGPointMake(listFrame.origin.x, -(CGRectGetHeight(listFrame) + kListTopMarginHeight));
                         self.listView.frame = listFrame;
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
         usingSpringWithDamping:0.74f
          initialSpringVelocity:0.6f
                        options:0
                     animations:^{
                         self.backgroundView.layer.opacity = 0.0f;

                         CGRect listFrame = self.listView.frame;
                         listFrame.origin = CGPointMake(listFrame.origin.x, -kListTopMarginHeight);
                         self.listView.frame = listFrame;
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
