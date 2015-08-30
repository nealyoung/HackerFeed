//
//  HFButtonTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 1/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFButtonTableViewCell.h"

@implementation HFButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.button];
        
        [self applyTheme];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
    }
    
    return self;
}

- (void)applyTheme {
    [super applyTheme];
    [self.button setTitleColor:[HFInterfaceTheme activeTheme].accentColor forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightSemibold];
}

@end
