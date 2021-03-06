//
//  HFUserInfoTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFUserInfoTableViewCell.h"

@implementation HFUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.usernameLabel];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.ageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.ageLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_usernameLabel]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_usernameLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_ageLabel]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_ageLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[_usernameLabel][_ageLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_usernameLabel, _ageLabel)]];
        
        [self applyTheme];
    }
    
    return self;
}

- (void)applyTheme {
    [super applyTheme];
    
    self.usernameLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleHeadline];
    self.usernameLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
    
    self.ageLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.ageLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleCaption1];
}

@end
