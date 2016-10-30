#import "UIColor+HFAdditions.h"

static NSString * const kColorThemeDefaultsKey = @"HFColorThemeSetting";

@implementation UIColor (HFAdditions)

- (UIColor *)hf_colorDarkenedByFactor:(CGFloat)factor {
    CGFloat r, g, b, a;
    
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MAX(r - factor, 0.0f)
                               green:MAX(g - factor, 0.0f)
                                blue:MAX(b - factor, 0.0f)
                               alpha:a];
    }
    
    return nil;
}

- (UIColor *)hf_colorLightenedByFactor:(CGFloat)factor {
    CGFloat r, g, b, a;
    
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MIN(r + factor, 1.0f)
                               green:MIN(g + factor, 1.0f)
                                blue:MIN(b + factor, 1.0f)
                               alpha:a];
    }
    
    return nil;
}

@end
