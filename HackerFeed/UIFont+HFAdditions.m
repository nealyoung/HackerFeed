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

+ (UIFont *)applicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
}

+ (UIFont *)lightApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Light" size:size];
}

+ (UIFont *)boldApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Bold" size:size];
}

+ (UIFont *)semiboldApplicationFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"SourceSansPro-Semibold" size:size];
}

+ (UIFont *)smallCapsApplicationFontWithSize:(CGFloat)size {
//    UIFont *font = [UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0f];
//    CFArrayRef  fontProperties  =  CTFontCopyFeatures ( ( __bridge CTFontRef ) font ) ;
//    NSLog(@"properties = %@", fontProperties);
    
    NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(37),
                                         UIFontFeatureSelectorIdentifierKey : @(1) }];
    
    NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
                                      UIFontDescriptorNameAttribute: @"SourceSansPro-Regular" } ;
    
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes];
    
    return [UIFont fontWithDescriptor:fontDescriptor size:size];
}

+ (UIFont *)smallCapsLightApplicationFontWithSize:(CGFloat)size {
    //    UIFont *font = [UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0f];
    //    CFArrayRef  fontProperties  =  CTFontCopyFeatures ( ( __bridge CTFontRef ) font ) ;
    //    NSLog(@"properties = %@", fontProperties);
    
    NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(37),
                                         UIFontFeatureSelectorIdentifierKey : @(1) }];
    
    NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
                                      UIFontDescriptorNameAttribute: @"SourceSansPro-Light" } ;
    
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes];
    
    return [UIFont fontWithDescriptor:fontDescriptor size:size];
}

+ (UIFont *)smallCapsSemiboldApplicationFontWithSize:(CGFloat)size {
    //    UIFont *font = [UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0f];
    //    CFArrayRef  fontProperties  =  CTFontCopyFeatures ( ( __bridge CTFontRef ) font ) ;
    //    NSLog(@"properties = %@", fontProperties);
    
    NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(37),
                                         UIFontFeatureSelectorIdentifierKey : @(1) }];
    
    NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
                                      UIFontDescriptorNameAttribute: @"SourceSansPro-Semibold" } ;
    
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes];
    
    return [UIFont fontWithDescriptor:fontDescriptor size:size];
}

@end
