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
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.opaque = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    // Vertically center the label within the comment box
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMidY(self.bounds) - (0.08f * CGRectGetHeight(self.bounds)));
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat cornerRadius = 4.0f;
    CGRect speechBubbleRect = CGRectMake(0.08f * CGRectGetWidth(rect),
                                         0.12f * CGRectGetHeight(rect),
                                         0.84f * CGRectGetWidth(rect),
                                         0.58f * CGRectGetHeight(rect));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Start in top left corner,
    CGPathMoveToPoint(path, NULL, speechBubbleRect.origin.x + cornerRadius, speechBubbleRect.origin.y ) ;
    
    CGFloat minX = CGRectGetMinX(speechBubbleRect);
    CGFloat minY = CGRectGetMinY(speechBubbleRect);

    CGFloat maxX = CGRectGetMaxX(speechBubbleRect);
    CGFloat maxY = CGRectGetMaxY(speechBubbleRect);
    
    // Move to top right corner
    CGPathAddArcToPoint(path,
                        NULL,
                        maxX,
                        minY,
                        maxX,
                        minY + cornerRadius,
                        cornerRadius);
    
    // Bottom right corner
    CGPathAddArcToPoint(path,
                        NULL,
                        maxX,
                        maxY,
                        maxX - cornerRadius,
                        maxY,
                        cornerRadius);
    
    // Right side of bottom triangle
    CGPathAddArcToPoint(path,
                        NULL,
                        minX + CGRectGetWidth(speechBubbleRect) * 0.5f,
                        maxY,
                        minX + CGRectGetWidth(speechBubbleRect) * 0.5f,
                        maxY,
                        cornerRadius);
    
    // Bottom of triangle
    CGPathAddArcToPoint(path,
                        NULL,
                        minX + CGRectGetWidth(speechBubbleRect) * 0.24f,
                        maxY + CGRectGetHeight(speechBubbleRect) * 0.38f,
                        minX + CGRectGetWidth(speechBubbleRect) * 0.24f,
                        maxY + CGRectGetHeight(speechBubbleRect) * 0.38f,
                        cornerRadius);
    
    // Left side of bottom triangle
    CGPathAddArcToPoint(path,
                        NULL,
                        minX + CGRectGetWidth(speechBubbleRect) * 0.24f,
                        maxY,
                        minX + CGRectGetWidth(speechBubbleRect) * 0.24f,
                        maxY,
                        cornerRadius);
    
    // Bottom left corner
    CGPathAddArcToPoint(path,
                        NULL,
                        minX,
                        maxY,
                        minX,
                        maxY - cornerRadius,
                        cornerRadius);
    
    // Top right corner
    CGPathAddArcToPoint(path,
                        NULL,
                        minX,
                        minY,
                        minX + cornerRadius,
                        minY, cornerRadius);
    
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGColorRef strokeColor = self.enabled ? [HFInterfaceTheme activeTheme].accentColor.CGColor : [[HFInterfaceTheme activeTheme].secondaryTextColor hf_colorLightenedByFactor:0.2f].CGColor;
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextStrokePath(ctx);
}

- (void)applyTheme {
    self.titleLabel.font = [UIFont semiboldApplicationFontOfSize:16.0f];
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
