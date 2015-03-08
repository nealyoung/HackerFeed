//
//  UIFont+HFAdditions.h
//  HackerFeed
//
//  Created by Nealon Young on 3/3/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HFFontFamily) {
    HFFontFamilySourceSansPro,
    HFFontFamilyAvenirNext,
    HFFontFamilyHelveticaNeue
};

static NSString * const kFontFamilyDefaultsKey = @"HFFontFamilySetting";

@interface UIFont (HFAdditions)

+ (NSString *)activeFontFamily;
+ (void)setActiveFontFamily:(NSString *)family;

+ (NSArray *)availableFontFamilies;

+ (UIFont *)preferredApplicationFontForTextStyle:(NSString *)textStyle;

+ (UIFont *)applicationFontOfSize:(CGFloat)size;
+ (UIFont *)boldApplicationFontOfSize:(CGFloat)size;
+ (UIFont *)semiboldApplicationFontOfSize:(CGFloat)size;

+ (UIFont *)smallCapsApplicationFontWithSize:(CGFloat)size;
+ (UIFont *)smallCapsLightApplicationFontWithSize:(CGFloat)size;
+ (UIFont *)smallCapsSemiboldApplicationFontWithSize:(CGFloat)size;

@end
