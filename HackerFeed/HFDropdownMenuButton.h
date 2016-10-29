//
//  HFDropdownMenuButton.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import UIKit;

#import "HFDropdownMenuItem.h"

@interface HFDropdownMenuButton : UIButton

@property UIImageView *iconImageView;

- (instancetype)initWithItem:(HFDropdownMenuItem *)item;

@end
