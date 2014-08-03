//
//  HFCommentTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFCommentTableViewCell.h"

#import "HFTextView.h"

@implementation HFCommentTableViewCell

- (void)awakeFromNib {
    self.usernameLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.textView.font = [UIFont applicationFontOfSize:14.0f];
}

- (void)setExpanded:(BOOL)expanded {
    [self setExpanded:expanded animated:YES];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (expanded) {
        self.separatorInset = UIEdgeInsetsMake(0.0f, CGRectGetWidth(self.frame), 0.0f, 0.0f);
    } else {
        self.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);;
    }
    
    self.toolbarHeightConstraint.constant = expanded ? 40.0f : 0.0f;
    [self setNeedsUpdateConstraints];
    
    NSTimeInterval animationDuration = animated ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        if (expanded) {
            self.contentView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1.0f];
            self.actionsView.layer.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f].CGColor;
            CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 0);
            transform.m34 = -1.0f / 500.0f;
            //self.actionsView.layer.transform = transform;
        } else {
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.actionsView.layer.backgroundColor = [UIColor blackColor].CGColor;
            CATransform3D transform = CATransform3DMakeRotation(M_PI_2, -1, 0, 0);
            transform.m34 = -1.0f / 500.0f;
            //self.actionsView.layer.transform = transform;
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate) {
        [self.delegate commentTableViewCellTapped:self];
    }
}

@end
