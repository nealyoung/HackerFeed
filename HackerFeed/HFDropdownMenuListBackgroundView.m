#import "HFDropdownMenuListBackgroundView.h"
#import "HFDropdownMenuButton.h"
#import "HFInterfaceTheme.h"

static CGFloat const kHFDropdownMenuArrowWidth = 24.0f;
static CGFloat const kHFDropdownMenuArrowHeight = 16.0f;
static CGFloat const kHFDropdownMenuButtonHeight = 40.0f;
static CGFloat const kHFDropdownMenuCornerRadius = 12.0f;

@implementation HFDropdownMenuListBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.54f;
        self.layer.shadowRadius = 28.0f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }

    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

- (void)setButtons:(NSArray<HFDropdownMenuButton *> *)buttons {
    _buttons = buttons;

    for (HFDropdownMenuButton *button in buttons) {
        [self addSubview:button];
    }
}

- (void)layoutSubviews {
    self.layer.shadowPath = [self backgroundPath];

    [self.buttons enumerateObjectsUsingBlock:^(HFDropdownMenuButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(0.0f,
                                  kHFDropdownMenuArrowHeight + kHFDropdownMenuButtonHeight * idx,
                                  CGRectGetWidth(self.bounds),
                                  kHFDropdownMenuButtonHeight);
    }];
}

- (CGPathRef)backgroundPath {
    CGMutablePathRef path = CGPathCreateMutable();

    CGRect backgroundRect = CGRectMake(0.0f, kHFDropdownMenuArrowHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kHFDropdownMenuArrowHeight);

    CGFloat minX = CGRectGetMinX(backgroundRect);
    CGFloat minY = CGRectGetMinY(backgroundRect);

    CGFloat maxX = CGRectGetMaxX(backgroundRect);
    CGFloat maxY = CGRectGetMaxY(backgroundRect);

    // Start in top left corner
    CGPathMoveToPoint(path, NULL, backgroundRect.origin.x + kHFDropdownMenuCornerRadius, backgroundRect.origin.y);

    // Left side of top triangle
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(backgroundRect) - (kHFDropdownMenuArrowWidth / 2.0f), minY);

    // Top of triangle
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(backgroundRect), minY - kHFDropdownMenuArrowHeight);

    // Right side of top triangle
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(backgroundRect) + (kHFDropdownMenuArrowWidth / 2.0f), minY);

    // Move to top right corner
    CGPathAddArcToPoint(path,
                        NULL,
                        maxX,
                        minY,
                        maxX,
                        minY + kHFDropdownMenuCornerRadius,
                        kHFDropdownMenuCornerRadius);

    // Bottom right corner
    CGPathAddArcToPoint(path,
                        NULL,
                        maxX,
                        maxY,
                        maxX - kHFDropdownMenuCornerRadius,
                        maxY,
                        kHFDropdownMenuCornerRadius);

    // Bottom left corner
    CGPathAddArcToPoint(path,
                        NULL,
                        minX,
                        maxY,
                        minX,
                        maxY - kHFDropdownMenuCornerRadius,
                        kHFDropdownMenuCornerRadius);

    // Top right corner
    CGPathAddArcToPoint(path,
                        NULL,
                        minX,
                        minY,
                        minX + kHFDropdownMenuCornerRadius,
                        minY, kHFDropdownMenuCornerRadius);
    
    CGPathCloseSubpath(path);

    return path;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, [self backgroundPath]);
    CGContextSetFillColorWithColor(ctx, [HFInterfaceTheme activeTheme].backgroundColor.CGColor);

    CGContextFillPath(ctx);
}

- (void)applyTheme {

}

@end
