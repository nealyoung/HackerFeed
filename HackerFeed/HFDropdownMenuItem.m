//
//  HFDropdownMenuItem.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFDropdownMenuItem.h"

#import "HFDropdownMenuButton.h"

@implementation HFDropdownMenuItem

- (void)setImage:(UIImage *)image {
    _image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([self.view isKindOfClass:[HFDropdownMenuButton class]]) {
        HFDropdownMenuButton *button = (HFDropdownMenuButton *)self.view;
        button.iconImageView.image = _image;
    }
}

@end
