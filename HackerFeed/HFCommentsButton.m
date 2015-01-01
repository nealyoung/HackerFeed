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
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMidY(self.bounds) - (0.06f * CGRectGetHeight(self.bounds)));
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* ovalPath = UIBezierPath.bezierPath;
    [ovalPath moveToPoint: CGPointMake(20.5, 62.5)];
    [ovalPath addCurveToPoint: CGPointMake(17.5, 75.5) controlPoint1: CGPointMake(21.15, 67.45) controlPoint2: CGPointMake(17.5, 75.5)];
    [ovalPath addCurveToPoint: CGPointMake(39.52, 66.2) controlPoint1: CGPointMake(17.5, 75.5) controlPoint2: CGPointMake(32.99, 65.28)];
    [ovalPath addCurveToPoint: CGPointMake(84.15, 57.17) controlPoint1: CGPointMake(55.14, 68.39) controlPoint2: CGPointMake(72.03, 65.38)];
    [ovalPath addCurveToPoint: CGPointMake(84.15, 10.22) controlPoint1: CGPointMake(103.28, 44.2) controlPoint2: CGPointMake(103.28, 23.19)];
    [ovalPath addCurveToPoint: CGPointMake(14.85, 10.22) controlPoint1: CGPointMake(65.01, -2.74) controlPoint2: CGPointMake(33.99, -2.74)];
    [ovalPath addCurveToPoint: CGPointMake(14.85, 57.17) controlPoint1: CGPointMake(-4.28, 23.19) controlPoint2: CGPointMake(-4.28, 44.2)];
    [ovalPath addCurveToPoint: CGPointMake(20.5, 62.5) controlPoint1: CGPointMake(15.61, 57.68) controlPoint2: CGPointMake(20.09, 59.35)];
    [ovalPath closePath];
    [UIColor.lightGrayColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];

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
