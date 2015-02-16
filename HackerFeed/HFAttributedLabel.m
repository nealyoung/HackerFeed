//
//  HFAttributedLabel.m
//  HackerFeed
//
//  Created by Nealon Young on 2/15/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFAttributedLabel.h"

@implementation HFAttributedLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.frame);
    [self setNeedsUpdateConstraints];
}

@end
