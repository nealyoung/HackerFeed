//
//  UIFont+HFAdditions.h
//  HackerFeed
//
//  Created by Nealon Young on 3/3/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "UIFont+HFAdditions.h"

#import <CoreText/CoreText.h>

@implementation UIFont (HFAdditions)

+ (NSString *)activeFontFamily {
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey]) {
        case HFFontFamilyAvenirNext:
            return @"Avenir Next";
            break;
            
        case HFFontFamilyHelveticaNeue:
            return @"Helvetica Neue";
            break;
            
        default:
            return @"Source Sans Pro";
            break;
    }
}

+ (void)setActiveFontFamily:(NSString *)family {
    if ([family isEqualToString:@"Avenir Next"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:HFFontFamilyAvenirNext forKey:kFontFamilyDefaultsKey];
    } else if ([family isEqualToString:@"Helvetica Neue"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:HFFontFamilyHelveticaNeue forKey:kFontFamilyDefaultsKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:HFFontFamilySourceSansPro forKey:kFontFamilyDefaultsKey];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangedNotificationName object:nil];
}

+ (NSArray *)availableFontFamilies {
    return @[@"Source Sans Pro",
             @"Avenir Next",
             @"Helvetica Neue"];
}

+ (UIFont *)preferredApplicationFontForTextStyle:(NSString *)textStyle {
    return [UIFont preferredFontForTextStyle:textStyle];
    
    UIFontDescriptor *preferredSystemFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:textStyle];
    CGFloat preferredFontSize = preferredSystemFontDescriptor.pointSize;
    
    if ([textStyle isEqualToString:UIFontTextStyleBody]) {
        return [UIFont applicationFontOfSize:preferredFontSize * 0.9f];
    } else if ([textStyle isEqualToString:UIFontTextStyleCaption1]) {
        return [UIFont applicationFontOfSize:preferredFontSize * 1.2f];
    } else if ([textStyle isEqualToString:UIFontTextStyleCaption2]) {
        return [UIFont applicationFontOfSize:preferredFontSize];
    } else if ([textStyle isEqualToString:UIFontTextStyleFootnote]) {
        return [UIFont applicationFontOfSize:preferredFontSize];
    } else if ([textStyle isEqualToString:UIFontTextStyleHeadline]) {
        return [UIFont applicationFontOfSize:preferredFontSize];
    } else if ([textStyle isEqualToString:UIFontTextStyleSubheadline]) {
        return [UIFont applicationFontOfSize:preferredFontSize];
    }
    
    return nil;
}

+ (UIFont *)applicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
    
//    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey]) {
//        case HFFontFamilyAvenirNext:
//            return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
//            break;
//            
//        case HFFontFamilyHelveticaNeue:
//            return [UIFont fontWithName:@"HelveticaNeue" size:size];
//            break;
//            
//        default:
//            return [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
//            break;
//    }
}

+ (UIFont *)lightApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-UltraLight" size:size];

//    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey]) {
//        case HFFontFamilyAvenirNext:
//            return [UIFont fontWithName:@"AvenirNext-UltraLight" size:size];
//            break;
//            
//        case HFFontFamilyHelveticaNeue:
//            return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
//            break;
//            
//        default:
//            return [UIFont fontWithName:@"SourceSansPro-Light" size:size];
//            break;
//    }
}

+ (UIFont *)boldApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Bold" size:size];

//    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey]) {
//        case HFFontFamilyAvenirNext:
//            return [UIFont fontWithName:@"AvenirNext-Bold" size:size];
//            break;
//            
//        case HFFontFamilyHelveticaNeue:
//            return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
//            break;
//            
//        default:
//            return [UIFont fontWithName:@"SourceSansPro-Bold" size:size];
//            break;
//    }
}

+ (UIFont *)semiboldApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Medium" size:size];

//    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey]) {
//        case HFFontFamilyAvenirNext:
//            return [UIFont fontWithName:@"AvenirNext-Medium" size:size];
//            break;
//            
//        case HFFontFamilyHelveticaNeue:
//            return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
//            break;
//            
//        default:
//            return [UIFont fontWithName:@"SourceSansPro-Semibold" size:size];
//            break;
//    }
}

+ (UIFont *)smallCapsApplicationFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];

//    font = [UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0f];
//    fontProperties  =  CTFontCopyFeatures ( ( __bridge CTFontRef ) font ) ;
//    NSLog(@"properties = %@", fontProperties);
    
//    NSString *fontName;
//    
//    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey]) {
//        case HFFontFamilyAvenirNext:
//            fontName = @"AvenirNext-Regular";
//            break;
//            
//        case HFFontFamilyHelveticaNeue:
//            fontName = @"HelveticaNeue";
//            break;
//            
//        default:
//            fontName = @"SourceSansPro-Regular";
//            break;
//    }
//    
//    UIFont *font = [UIFont fontWithName:fontName size:16.0f];
//    CFArrayRef fontProperties  =  CTFontCopyFeatures ( ( __bridge CTFontRef ) font ) ;
//    
//    NSLog(@"%@ properties: %@", font, fontProperties);
//    
//    NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(37),
//                                         UIFontFeatureSelectorIdentifierKey : @(1) }];
//    
//    NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
//                                      UIFontDescriptorNameAttribute: fontName } ;
//    
//    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes];
//    
//    
//    CTFontRef fontRef = CTFontCreateWithFontDescriptor((( __bridge CTFontDescriptorRef )fontDescriptor), size, NULL);
//    font = [UIFont fontWithDescriptor:fontDescriptor size:size];
//    CFArrayRef fontSettings  =  CTFontCopyFeatureSettings( fontRef ) ;
//    
//    NSLog(@"%@ properties: %@", font, fontSettings);
//    
//    return [UIFont fontWithDescriptor:fontDescriptor size:size];
}

+ (UIFont *)smallCapsLightApplicationFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-UltraLight" size:size];

//    NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(37),
//                                         UIFontFeatureSelectorIdentifierKey : @(1) }];
//    
//    NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
//                                      UIFontDescriptorNameAttribute: @"SourceSansPro-Light" } ;
//    
//    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes];
//    
//    return [UIFont fontWithDescriptor:fontDescriptor size:size];
}

+ (UIFont *)smallCapsSemiboldApplicationFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Medium" size:size];

//    NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(37),
//                                         UIFontFeatureSelectorIdentifierKey : @(1) }];
//    
//    NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
//                                      UIFontDescriptorNameAttribute: @"SourceSansPro-Semibold" } ;
//    
//    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes];
//    
//    return [UIFont fontWithDescriptor:fontDescriptor size:size];
}

@end
