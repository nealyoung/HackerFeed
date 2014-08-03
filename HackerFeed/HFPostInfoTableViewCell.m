//
//  HFPostInfoTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostInfoTableViewCell.h"

@implementation HFPostInfoTableViewCell

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont applicationFontOfSize:18.0f];
    self.infoLabel.font = [UIFont smallCapsApplicationFontWithSize:self.infoLabel.font.pointSize];
}

@end
