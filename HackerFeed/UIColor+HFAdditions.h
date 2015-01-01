//
//  UIColor+HFAdditions.h
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HFColorTheme) {
    HFColorThemeDefault,
    HFColorThemeDark
};

@interface UIColor (HFAdditions)

+ (HFColorTheme)hf_currentColorTheme;
+ (void)hf_setCurrentColorTheme:(HFColorTheme)theme;

+ (UIColor *)applicationColor;
+ (UIColor *)hf_themedAccentColor;
+ (UIColor *)hf_themedTextColor;
+ (UIColor *)hf_themedSecondaryTextColor;
+ (UIColor *)hf_themedBackgroundColor;
+ (UIColor *)hf_themedNavigationBarColor;
+ (UIStatusBarStyle)hf_themedStatusBarStyle;

- (UIColor *)hf_colorDarkenedByFactor:(CGFloat)factor;

@end
