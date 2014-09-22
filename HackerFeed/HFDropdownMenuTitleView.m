//
//  HFDropdownMenuTitleView.m
//  HackerFeed
//
//  Created by Nealon Young on 9/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFDropdownMenuTitleView.h"

@interface _HFDropdownMenuTitleViewIndicator : UIView

@end

@implementation _HFDropdownMenuTitleViewIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.opaque = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = UIBezierPath.bezierPath;
    
    [bezierPath moveToPoint: CGPointMake(15, 2)];
    [bezierPath addCurveToPoint: CGPointMake(7.5, 9) controlPoint1: CGPointMake(15, 2) controlPoint2: CGPointMake(7.5, 9)];
    [bezierPath addLineToPoint: CGPointMake(0, 2)];
    [bezierPath addLineToPoint: CGPointMake(1.5, 2)];
    [bezierPath addCurveToPoint: CGPointMake(7.5, 7.6) controlPoint1: CGPointMake(3.69, 4.04) controlPoint2: CGPointMake(7.5, 7.6)];
    [bezierPath addCurveToPoint: CGPointMake(13.5, 2) controlPoint1: CGPointMake(7.5, 7.6) controlPoint2: CGPointMake(11.31, 4.04)];
    [bezierPath addLineToPoint: CGPointMake(15, 2)];
    [bezierPath addLineToPoint: CGPointMake(15, 2)];
    [bezierPath closePath];
    [[UIColor darkGrayColor] setFill];
    
    [bezierPath fill];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(15.0f, 10.0f);
}

@end

@interface HFDropdownMenuTitleView ()

@property _HFDropdownMenuTitleViewIndicator *indicator;

@end

@implementation HFDropdownMenuTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.font = [UIFont applicationFontOfSize:18.0f];
        self.titleLabel.textColor = [UIColor applicationColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.indicator = [[_HFDropdownMenuTitleViewIndicator alloc] initWithFrame:CGRectZero];
        [self.indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.indicator];
        
        // Center the label in the view
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        // Vertically center and position the icon to the right of the label
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_titleLabel]-6-[_indicator]"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_titleLabel, _indicator)]];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(18.0f + [self.titleLabel intrinsicContentSize].width + [self.indicator intrinsicContentSize].width,
                      [self.titleLabel intrinsicContentSize].height);
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    CATransform3D transform;
    
    if (expanded) {
        transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
    } else {
        transform = CATransform3DIdentity;
    }
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.indicator.layer.transform = transform;
                     }
                     completion:nil];
}

@end
