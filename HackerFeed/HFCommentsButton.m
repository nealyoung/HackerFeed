//
//  HFCommentsButton.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFCommentsButton.h"

@interface HFCommentsButton ()

@end

@implementation HFCommentsButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    [self setImage:[[UIImage imageNamed:@"CommentsIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeCenter;
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    // Vertically center the label within the comment box
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMidY(self.bounds) - (0.08f * CGRectGetHeight(self.bounds)));
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//    CGPathMoveToPoint(path, NULL, CGRectGetWidth(rect) * 0.08f, CGRectGetHeight(rect) * 0.15f);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.08f, CGRectGetHeight(rect) * 0.7f);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.29f, CGRectGetHeight(rect) * 0.7f);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.27f, CGRectGetHeight(rect) * 0.9f);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.5f, CGRectGetHeight(rect) * 0.7f);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.92f, CGRectGetHeight(rect) * 0.7f);
//    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.92f, CGRectGetHeight(rect) * 0.15f);
//    CGPathCloseSubpath(path);
//    CGContextAddPath(ctx, path);
//    CGColorRef strokeColor = self.tintColor.CGColor;
//    CGContextSetStrokeColorWithColor(ctx, strokeColor);
//    CGContextSetLineWidth(ctx, 1.0f);
//    
//    CGContextStrokePath(ctx);
//}

- (void)applyTheme {
    self.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
}

- (void)setEnabled:(BOOL)enabled {
    if (enabled) {
        [self setImage:[[UIImage imageNamed:@"CommentsIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    } else {
        [self setImage:[[UIImage imageNamed:@"JobsIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    [super setEnabled:enabled];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
