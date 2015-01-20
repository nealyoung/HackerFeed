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
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kThemeChangedNotificationName
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [self applyTheme];
                                                      }];
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
    self.barTintColor = [UIColor hf_themedNavigationBarColor];
    self.bottomBorderView.backgroundColor = [UIColor hf_themedAccentColor];
}

@end
