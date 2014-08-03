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
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.usernameLabel.font = [UIFont applicationFontOfSize:18.0f];
    self.ageLabel.font = [UIFont smallCapsApplicationFontWithSize:self.ageLabel.font.pointSize];
}

@end
