//
//  HFBorderedButton.m
//  HackerFeed
//
//  Created by Nealon Young on 7/25/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFBorderedButton.h"

@implementation HFBorderedButton

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

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self setNeedsDisplay];
}

- (void)commonInit {
    // Center the title vertically (small caps font is slightly lower than center)
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 2.0f, 0.0f);
    self.titleLabel.font = [UIFont smallCapsApplicationFontWithSize:self.titleLabel.font.pointSize];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    
    if (self.state == UIControlStateHighlighted) {
        self.layer.backgroundColor = self.tintColor.CGColor;
        [self setTitleColor:self.superview.backgroundColor forState:UIControlStateHighlighted];
    } else {
        self.layer.backgroundColor = nil;
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
}

@end
