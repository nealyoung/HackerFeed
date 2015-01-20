//
//  HFTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 8/5/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFTableViewCell.h"

@implementation HFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    NSTimeInterval animationDuration = animated ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        if (highlighted) {
            self.textLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
            self.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
            self.contentView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
        } else {
            self.textLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
            self.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
            self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    NSTimeInterval animationDuration = animated ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        if (selected) {
            self.textLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
            self.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
            self.contentView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
        } else {
            self.textLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
            self.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
            self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
        }
    }];
}

- (void)applyTheme {
    self.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
    self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
    
    self.textLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.textLabel.textColor = [HFInterfaceTheme activeTheme].textColor;

    self.detailTextLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.detailTextLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
