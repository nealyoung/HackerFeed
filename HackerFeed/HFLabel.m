//
//  HFLabel.m
//  HackerFeed
//
//  Created by Nealon Young on 8/6/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFLabel.h"

@implementation HFLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.frame);
    [self setNeedsUpdateConstraints];
}

@end
