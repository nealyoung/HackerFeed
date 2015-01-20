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
            self.textLabel.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.25f];
            self.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.25f];
            self.contentView.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.25f];
        } else {
            self.textLabel.backgroundColor = [UIColor hf_themedBackgroundColor];
            self.backgroundColor = [UIColor hf_themedBackgroundColor];
            self.contentView.backgroundColor = [UIColor hf_themedBackgroundColor];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    NSTimeInterval animationDuration = animated ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        if (selected) {
            self.textLabel.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.25f];
            self.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.25f];
            self.contentView.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.25f];
        } else {
            self.textLabel.backgroundColor = [UIColor hf_themedBackgroundColor];
            self.backgroundColor = [UIColor hf_themedBackgroundColor];
            self.contentView.backgroundColor = [UIColor hf_themedBackgroundColor];
        }
    }];
}

- (void)applyTheme {
    self.backgroundColor = [UIColor hf_themedBackgroundColor];
    self.contentView.backgroundColor = [UIColor hf_themedBackgroundColor];
    
    self.textLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.textLabel.textColor = [UIColor hf_themedTextColor];

    self.detailTextLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.detailTextLabel.textColor = [UIColor hf_themedSecondaryTextColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
