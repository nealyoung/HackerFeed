//
//  UIColor+HFAdditions.m
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "UIColor+HFAdditions.h"

static NSString * const kColorThemeDefaultsKey = @"HFColorThemeSetting";

@implementation UIColor (HFAdditions)

+ (HFColorTheme)hf_currentColorTheme {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kColorThemeDefaultsKey];
}

+ (void)hf_setCurrentColorTheme:(HFColorTheme)theme {
    [[NSUserDefaults standardUserDefaults] setInteger:theme forKey:kColorThemeDefaultsKey];
}

+ (UIColor *)applicationColor {
    return [UIColor colorWithRed:0.99f green:0.40f blue:0.13f alpha:1.0f];
}

+ (UIColor *)hf_themedAccentColor {
    switch ([UIColor hf_currentColorTheme]) {
        case HFColorThemeDark:
            return [UIColor colorWithRed:0.91f green:0.66f blue:0.44f alpha:1.0f];
            break;
            
        default:
            return [UIColor colorWithRed:0.99f green:0.40f blue:0.13f alpha:1.0f];
            break;
    }
}

+ (UIColor *)hf_themedTextColor {
    switch ([UIColor hf_currentColorTheme]) {
        case HFColorThemeDark:
            return [UIColor colorWithRed:0.91f green:0.66f blue:0.44f alpha:1.0f];
            break;
            
        default:
            return [UIColor blackColor];
            break;
    }
}

+ (UIColor *)hf_themedSecondaryTextColor {
    switch ([UIColor hf_currentColorTheme]) {
        case HFColorThemeDark:
            return [UIColor colorWithWhite:0.6f alpha:1.0f];
            break;
            
        default:
            return [UIColor colorWithWhite:0.33f alpha:1.0f];
            break;
    }
}

+ (UIColor *)hf_themedBackgroundColor {
    switch ([UIColor hf_currentColorTheme]) {
        case HFColorThemeDark:
            return [UIColor colorWithWhite:0.12f alpha:1.0f];
            break;
            
        default:
            return [UIColor colorWithWhite:0.98 alpha:1.0f];
            break;
    }
}

+ (UIColor *)hf_themedNavigationBarColor {
    switch ([UIColor hf_currentColorTheme]) {
        case HFColorThemeDark:
            return [UIColor colorWithWhite:0.13f alpha:1.0f];
            break;
            
        default:
            return nil;
            break;
    }
}

+ (UIStatusBarStyle)hf_themedStatusBarStyle {
    switch ([UIColor hf_currentColorTheme]) {
        case HFColorThemeDark:
            return UIStatusBarStyleLightContent;
            break;
            
        default:
            return UIStatusBarStyleDefault;
            break;
    }
}

- (UIColor *)hf_colorDarkenedByFactor:(CGFloat)factor {
    CGFloat r, g, b, a;
    
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MAX(r - factor, 0.0)
                               green:MAX(g - factor, 0.0)
                                blue:MAX(b - factor, 0.0)
                               alpha:a];
    }
    
    return nil;
}

@end
