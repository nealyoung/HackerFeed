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
    self.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Vertically center the label within the comment box
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x,
                                         self.titleLabel.center.y - (0.05f * CGRectGetHeight(self.frame)));
    
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetWidth(rect) * 0.1f, CGRectGetHeight(rect) * 0.15f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.1f, CGRectGetHeight(rect) * 0.7f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.29f, CGRectGetHeight(rect) * 0.7f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.27f, CGRectGetHeight(rect) * 0.9f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.5f, CGRectGetHeight(rect) * 0.7f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.9f, CGRectGetHeight(rect) * 0.7f);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect) * 0.9f, CGRectGetHeight(rect) * 0.15f);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGColorRef strokeColor = self.tintColor.CGColor;
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextStrokePath(ctx);
}

@end
