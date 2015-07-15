//
//  HFTextField.m
//  HackerFeed
//
//  Created by Nealon Young on 7/14/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFTextField.h"

@interface HFTextField ()

@property UIView *bottomBorderView;

@end

@implementation HFTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.bottomBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.bottomBorderView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomBorderView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_bottomBorderView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomBorderView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_bottomBorderView)]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomBorderView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0f
                                                          constant:1.0f / [UIScreen mainScreen].scale]];
        
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    UIColor *placeholderTextColor = [[HFInterfaceTheme activeTheme].secondaryTextColor hf_colorLightenedByFactor:0.3f];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                                attributes:@{ NSForegroundColorAttributeName : placeholderTextColor }];
    self.attributedPlaceholder = attributedPlaceholder;
}

- (void)applyTheme {
    if (self.placeholder) {
        UIColor *placeholderTextColor = [[HFInterfaceTheme activeTheme].secondaryTextColor hf_colorLightenedByFactor:0.3f];
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                                    attributes:@{ NSForegroundColorAttributeName : placeholderTextColor }];
        self.attributedPlaceholder = attributedPlaceholder;
    }

//    self.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.08f];
    self.bottomBorderView.backgroundColor = [[HFInterfaceTheme activeTheme] accentColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
