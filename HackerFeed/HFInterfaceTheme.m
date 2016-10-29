//
//  HFInterfaceTheme.m
//  HackerFeed
//
//  Created by Nealon Young on 1/1/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFInterfaceTheme.h"
#import "SVProgressHUD.h"

static NSString * const kColorThemeDefaultsKey = @"HFColorThemeSetting";
static HFInterfaceTheme *_activeTheme;

@implementation HFInterfaceTheme

+ (void)setupAppearanceForActiveTheme {
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class]]] setFont:[UIFont systemFontOfSize:15.0f]];
    
    NSDictionary *barButtonItemTitleTextAttributes = @{NSForegroundColorAttributeName:[[HFInterfaceTheme activeTheme] accentColor],
                                                       NSFontAttributeName: [UIFont systemFontOfSize:18.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15.0f]];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName:[[HFInterfaceTheme activeTheme] accentColor],
                                                       NSFontAttributeName: [UIFont systemFontOfSize:19.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:[[HFInterfaceTheme activeTheme] navigationBarColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIToolbar appearance] setBarTintColor:[[HFInterfaceTheme activeTheme] navigationBarColor]];
    [[UIToolbar appearance] setTranslucent:NO];
    
#ifndef HF_SHARE_EXTENSION_TARGET
    [UIApplication sharedApplication].keyWindow.tintColor = [[HFInterfaceTheme activeTheme] accentColor];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
}

+ (HFInterfaceTheme *)activeTheme {
    if (!_activeTheme) {
        _activeTheme = [HFInterfaceTheme themeWithType:[[NSUserDefaults standardUserDefaults] integerForKey:kColorThemeDefaultsKey]];
    }
    
    return _activeTheme;
}

+ (void)setActiveTheme:(HFInterfaceTheme *)theme {
    _activeTheme = theme;
    [[NSUserDefaults standardUserDefaults] setInteger:theme.themeType forKey:kColorThemeDefaultsKey];
    
    [HFInterfaceTheme setupAppearanceForActiveTheme];
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangedNotificationName object:nil];
}

+ (HFInterfaceTheme *)themeWithType:(HFInterfaceThemeType)type {
    HFInterfaceTheme *interfaceTheme = [[HFInterfaceTheme alloc] init];
    interfaceTheme.themeType = type;
    
    if (type == HFInterfaceThemeTypeDefault) {
        interfaceTheme.title = NSLocalizedString(@"Light", nil);
        
        interfaceTheme.accentColor = [UIColor colorWithRed:0.90f green:0.40f blue:0.13f alpha:1.0f];
        interfaceTheme.textColor = [UIColor colorWithWhite:0.16f alpha:1.0f];
        interfaceTheme.secondaryTextColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
        interfaceTheme.placeholderTextColor = [UIColor colorWithWhite:0.63f alpha:1.0f];
        interfaceTheme.backgroundColor = [UIColor colorWithRed:1.0f green:0.99f blue:0.96f alpha:1.0f];
        interfaceTheme.navigationBarColor = [UIColor colorWithRed:1.0f green:0.99f blue:0.97f alpha:1.0f];
        
        interfaceTheme.statusBarStyle = UIStatusBarStyleDefault;
    } else if (type == HFInterfaceThemeTypeBlue) {
        interfaceTheme.title = NSLocalizedString(@"Blue", nil);
        
        interfaceTheme.accentColor = [UIColor colorWithWhite:0.84f alpha:1.0f];
        interfaceTheme.textColor = [UIColor colorWithWhite:0.84f alpha:1.0f];
        interfaceTheme.secondaryTextColor = [UIColor colorWithWhite:0.78f alpha:1.0f];
        interfaceTheme.placeholderTextColor = [UIColor colorWithWhite:0.58f alpha:1.0f];
        interfaceTheme.backgroundColor = [UIColor colorWithRed:0.14f green:0.19f blue:0.25f alpha:1.0f];
        interfaceTheme.navigationBarColor = [UIColor colorWithRed:0.16f green:0.22f blue:0.29f alpha:1.0f];
        
        interfaceTheme.statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        interfaceTheme.title = NSLocalizedString(@"Dark", nil);
        
//        interfaceTheme.accentColor = [UIColor colorWithRed:0.91f green:0.66f blue:0.44f alpha:1.0f];
//        interfaceTheme.textColor = [UIColor colorWithRed:0.91f green:0.66f blue:0.44f alpha:1.0f];
        interfaceTheme.accentColor = [UIColor colorWithRed:0.90f green:0.54f blue:0.30f alpha:1.0f];
        interfaceTheme.textColor = [UIColor colorWithRed:0.90f green:0.54f blue:0.30f alpha:1.0f];
        interfaceTheme.secondaryTextColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
        interfaceTheme.placeholderTextColor = [UIColor colorWithWhite:0.43f alpha:1.0f];
        interfaceTheme.backgroundColor = [UIColor colorWithWhite:0.12f alpha:1.0f];
        interfaceTheme.navigationBarColor = [UIColor colorWithWhite:0.13f alpha:1.0f];
        
        interfaceTheme.statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    interfaceTheme.cellSeparatorColor = [interfaceTheme.backgroundColor hf_colorDarkenedByFactor:0.06f];
    
    return interfaceTheme;
}

+ (NSArray *)allThemes {
    return @[[HFInterfaceTheme themeWithType:HFInterfaceThemeTypeDefault],
             [HFInterfaceTheme themeWithType:HFInterfaceThemeTypeBlue],
             [HFInterfaceTheme themeWithType:HFInterfaceThemeTypeDark]];
}

@end
