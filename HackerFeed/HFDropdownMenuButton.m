//
//  HFDropdownMenuButton.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFDropdownMenuButton.h"

@interface HFDropdownMenuButton ()

@property UIView *bottomBorderView;

- (void)applyTheme;

@end

@implementation HFDropdownMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.iconImageView = [[UIImageView alloc] initWithImage:nil];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconImageView];
        
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.bottomBorderView];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (instancetype)initWithItem:(HFDropdownMenuItem *)item {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setTitle:item.title forState:UIControlStateNormal];
        self.iconImageView.image = item.image;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(15.0f, 0, 30.0f, CGRectGetHeight(self.frame));
    
    self.bottomBorderView.frame = CGRectMake(15.0f,
                                             CGRectGetHeight(self.frame),
                                             CGRectGetWidth(self.frame) - 15.0f,
                                             1.0f / [UIScreen mainScreen].scale);
}

- (void)applyTheme {
    self.iconImageView.tintColor = [[HFInterfaceTheme activeTheme] accentColor];
    self.bottomBorderView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    self.bottomBorderView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.06f];
    [self setTitleColor:[HFInterfaceTheme activeTheme].textColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
