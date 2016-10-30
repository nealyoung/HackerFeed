@import UIKit;

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
