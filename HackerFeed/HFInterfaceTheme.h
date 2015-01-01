//
//  HFInterfaceTheme.h
//  HackerFeed
//
//  Created by Nealon Young on 1/1/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFInterfaceTheme : NSObject



@property UIColor *accentColor;
@property UIColor *textColor;
@property UIColor *secondaryTextColor;
@property UIColor *backgroundColor;
@property UIColor *navigationBarColor;

@property UIStatusBarStyle *statusBarStyle;

+ (HFInterfaceTheme *)activeTheme;
+ (void)setActiveTheme:(HFInterfaceTheme *)theme;
+ (NSArray *)allThemes;

@end
