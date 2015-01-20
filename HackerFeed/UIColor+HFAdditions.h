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
    HFColorThemeBlue,
    HFColorThemeDark
};

static NSString * const kThemeChangedNotificationName = @"ThemeChangedNotification";

@interface UIColor (HFAdditions)

- (UIColor *)hf_colorDarkenedByFactor:(CGFloat)factor;
- (UIColor *)hf_colorLightenedByFactor:(CGFloat)factor;

@end
