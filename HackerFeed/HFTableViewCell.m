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
        self.backgroundColor = [UIColor hf_themedBackgroundColor];
        self.contentView.backgroundColor = [UIColor hf_themedBackgroundColor];
        
        self.textLabel.font = [UIFont applicationFontOfSize:16.0f];
        
        self.detailTextLabel.font = [UIFont applicationFontOfSize:16.0f];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.5f];
        self.contentView.backgroundColor = [[UIColor hf_themedBackgroundColor] hf_colorDarkenedByFactor:0.5f];
    } else {
        self.backgroundColor = [UIColor hf_themedBackgroundColor];
        self.contentView.backgroundColor = [UIColor hf_themedBackgroundColor];
    }
}

@end
