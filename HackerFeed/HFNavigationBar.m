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

@end

@implementation HFNavigationBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomBorderView.backgroundColor = [UIColor applicationColor];
        [self addSubview:self.bottomBorderView];
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

@end
