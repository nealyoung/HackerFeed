@import Foundation;

typedef NS_ENUM(NSInteger, HFInterfaceThemeType) {
    HFInterfaceThemeTypeDefault,
    HFInterfaceThemeTypeBlue,
    HFInterfaceThemeTypeDark
};

@interface HFInterfaceTheme : NSObject

@property HFInterfaceThemeType themeType;
@property NSString *title;

@property UIColor *accentColor;
@property UIColor *textColor;
@property UIColor *secondaryTextColor;
@property UIColor *placeholderTextColor;
@property UIColor *backgroundColor;
@property UIColor *navigationBarColor;
@property UIColor *cellSeparatorColor;

@property UIStatusBarStyle statusBarStyle;

/**
 Configures global appearance settings using UIAppearance to reflect the active theme.
 */
+ (void)setupAppearanceForActiveTheme;

+ (HFInterfaceTheme *)activeTheme;
+ (void)setActiveTheme:(HFInterfaceTheme *)theme;

+ (HFInterfaceTheme *)themeWithType:(HFInterfaceThemeType)type;
+ (NSArray *)allThemes;

@end
