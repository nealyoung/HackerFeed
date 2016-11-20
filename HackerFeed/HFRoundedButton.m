#import "HFRoundedButton.h"
#import "UIFont+HFAdditions.h"

@implementation HFRoundedButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    UIBezierPath *roundedBezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.5f, 0.5f) cornerRadius:CGRectGetHeight(rect) / 2.0f];
    roundedBezierPath.lineWidth = 0.5f;
    [[HFInterfaceTheme activeTheme].cellSeparatorColor setStroke];
    [roundedBezierPath stroke];
}

- (void)applyTheme {
    [self setTitleColor:[HFInterfaceTheme activeTheme].secondaryTextColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleBody];

    self.imageView.tintColor = [[HFInterfaceTheme activeTheme].secondaryTextColor hf_colorLightenedByFactor:0.16f];

    [self setNeedsDisplay];
}

//- (UIEdgeInsets)contentEdgeInsets {
//    return UIEdgeInsetsMake(2.0f, 4.0f, 2.0f, 4.0f);
//}

- (UIEdgeInsets)imageEdgeInsets {
    CGRect contentBounds = CGRectInset(self.bounds, [self contentEdgeInsets].left, [self contentEdgeInsets].top);
    return UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, CGRectGetWidth(contentBounds) - 24.0f);
}

- (UIEdgeInsets)titleEdgeInsets {
    CGRect contentBounds = CGRectInset(self.bounds, [self contentEdgeInsets].left, [self contentEdgeInsets].top);
    return UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 8.0f);
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicContentSize = [super intrinsicContentSize];

    intrinsicContentSize.width += 32.0f;
    intrinsicContentSize.height += 4.0f;

    return intrinsicContentSize;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
