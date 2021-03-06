//
//  HFInterfaceTheme.h
//  HackerFeed
//
//  Created by Nealon Young on 1/1/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

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
