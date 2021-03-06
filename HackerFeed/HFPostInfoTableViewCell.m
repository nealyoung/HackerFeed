//
//  HFPostInfoTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostInfoTableViewCell.h"

@implementation HFPostInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.infoLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_infoLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_infoLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleLabel][_infoLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, _infoLabel)]];
        
        [self applyTheme];
    }
    
    return self;
}

- (void)applyTheme {
    [super applyTheme];
    
    self.titleLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
    self.titleLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleHeadline];

    self.infoLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.infoLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleSubheadline];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the max layout width of the multi-line information label to the calculated width of the label after auto layout has run
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    
    [self layoutIfNeeded];
}

@end
