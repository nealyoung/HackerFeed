//
//  HFDropdownMenu.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFDropdownMenu.h"

#import "HFDropdownMenuButton.h"

@interface HFDropdownMenu ()

@property (nonatomic) NSArray *buttons;
@property UIView *listView;
@property UIView *bottomBorderView;

- (void)buttonPressed:(HFDropdownMenuButton *)sender;

@end

const CGFloat kListTopMarginHeight = 80.0f;
const CGFloat kNavigationBarHeight = 64.0f;

@implementation HFDropdownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationDuration = 0.6f;
        _itemHeight = 44.0f;

        _listView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        //_listView.backgroundColor = [UIColor darkGrayColor];
        
        _listView.layer.cornerRadius = 0.0f;
        _listView.layer.masksToBounds = YES;
        [self addSubview:_listView];

        
        _bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorderView.backgroundColor = [UIColor darkGrayColor];
        [_listView addSubview:_bottomBorderView];
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
    
    CGFloat menuBackgroundHeight = kListTopMarginHeight + kNavigationBarHeight + self.itemHeight * [self.items count];
    self.listView.frame = CGRectMake(self.listView.frame.origin.x,
                                     -(menuBackgroundHeight + kListTopMarginHeight),
                                     CGRectGetWidth(self.frame),
                                     menuBackgroundHeight);
    
    [self.buttons enumerateObjectsUsingBlock:^(HFDropdownMenuButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(CGRectGetMinX(self.listView.frame),
                                  kListTopMarginHeight + kNavigationBarHeight + self.itemHeight * idx,
                                  CGRectGetWidth(self.listView.frame),
                                  self.itemHeight);
    }];
    
    self.bottomBorderView.frame = CGRectMake(0.0f,
                                             CGRectGetMaxY(((UIButton *)[self.buttons lastObject]).frame) - 1.0f,
                                             CGRectGetWidth(self.listView.frame),
                                             1.0f);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // Don't pick up touches unless the menu is showing and we want to dismiss it
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

- (void)setItems:(NSArray *)items {
    _items = items;
    
    NSMutableArray *buttons = [NSMutableArray array];
    for (HFDropdownMenuItem *item in items) {
        HFDropdownMenuButton *button = [[HFDropdownMenuButton alloc] initWithItem:item];
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
    self.selectedItem = self.items[sender.tag];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectItem:)]) {
        [self.delegate dropdownMenu:self didSelectItem:self.selectedItem];
    }
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
          initialSpringVelocity:1.0f
                        options:0
                     animations:^{
                         CGRect listFrame = self.listView.frame;
                         listFrame.origin = CGPointMake(0.0f, -(CGRectGetHeight(listFrame) + kListTopMarginHeight));
                         self.listView.frame = listFrame;
                         self.backgroundColor = [UIColor clearColor];
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
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.8f
                        options:0
                     animations:^{
                         CGRect listFrame = self.listView.frame;
                         listFrame.origin = CGPointMake(0.0f, -kListTopMarginHeight);
                         self.listView.frame = listFrame;
                         self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
                     }
                     completion:^(BOOL finished) {
                         if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
                             [self.delegate dropdownMenuDidShow:self];
                         }
                     }];
}

@end
