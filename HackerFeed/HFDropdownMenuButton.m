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

@end

@implementation HFDropdownMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomBorderView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
        [self addSubview:self.bottomBorderView];
        
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    return self;
}

- (instancetype)initWithItem:(HFDropdownMenuItem *)item {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setTitle:item.title forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bottomBorderView.frame = CGRectMake(15.0f,
                                             CGRectGetHeight(self.frame),
                                             CGRectGetWidth(self.frame) - 30.0f,
                                             1.0f / [UIScreen mainScreen].scale);
}

@end
