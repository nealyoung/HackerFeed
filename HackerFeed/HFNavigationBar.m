//
//  HFNavigationBar.m
//  HackerFeed
//
//  Created by Nealon Young on 8/9/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFNavigationBar.h"

@interface HFNavigationBar ()

@property UIView *bottomBorderView;

- (void)applyTheme;

@end

@implementation HFNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.bottomBorderView];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bottomBorderView.frame = CGRectMake(0,
                                             CGRectGetHeight(self.frame),
                                             CGRectGetWidth(self.frame),
                                             1.0f);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applyTheme {
    self.barTintColor = [[HFInterfaceTheme activeTheme] navigationBarColor];
    self.bottomBorderView.backgroundColor = [[HFInterfaceTheme activeTheme] accentColor];
}

@end
