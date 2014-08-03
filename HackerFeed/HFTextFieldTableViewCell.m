//
//  HFTextFieldTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 8/1/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFTextFieldTableViewCell.h"

@implementation HFTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.textField.font = [UIFont applicationFontOfSize:15.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
