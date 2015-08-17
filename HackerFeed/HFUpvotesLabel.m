//
//  HFUpvotesLabel.m
//  
//
//  Created by Nealon Young on 8/11/15.
//
//

#import "HFUpvotesLabel.h"

@implementation HFUpvotesLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
        
        self.textAlignment = NSTextAlignmentCenter;
        
        self.layer.shouldRasterize = YES;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 4.0f;
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    
    if (self.text) {
        size.width += 8.0f;
    }
    
    return size;
}

- (void)applyTheme {
    self.font = [UIFont semiboldApplicationFontOfSize:14.0f];
    self.layer.borderColor = [HFInterfaceTheme activeTheme].accentColor.CGColor;
    
    if (self.backgroundHighlighted) {
        self.backgroundColor = [HFInterfaceTheme activeTheme].accentColor;
        self.textColor = [HFInterfaceTheme activeTheme].backgroundColor;
    } else {
        // We don't make the label's backgroundColor transparent to avoid blended layers
        self.backgroundColor = self.superview.backgroundColor;
        self.textColor = [HFInterfaceTheme activeTheme].accentColor;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

- (void)setBackgroundHighlighted:(BOOL)backgroundHighlighted {
    _backgroundHighlighted = backgroundHighlighted;
    [self applyTheme];
}

@end
