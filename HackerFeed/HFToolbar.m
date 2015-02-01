//
//  HFToolbar.m
//  HackerFeed
//
//  Created by Nealon Young on 1/22/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFToolbar.h"

@interface HFToolbar ()

@property UIView *topBorderView;

- (void)applyTheme;

@end

@implementation HFToolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.topBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.topBorderView];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topBorderView.frame = CGRectMake(0.0f,
                                          0.0f,
                                          CGRectGetWidth(self.frame),
                                          1.0f);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applyTheme {
    self.barTintColor = [[HFInterfaceTheme activeTheme] navigationBarColor];
    self.topBorderView.backgroundColor = [[HFInterfaceTheme activeTheme] accentColor];
}

@end
