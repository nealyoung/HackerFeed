//
//  HFPostTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostTableViewCell.h"

@implementation HFPostTableViewCell

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.infoLabel.font = [UIFont smallCapsApplicationFontWithSize:self.infoLabel.font.pointSize];
    self.domainLabel.font = [UIFont smallCapsApplicationFontWithSize:self.domainLabel.font.pointSize];
}

@end
