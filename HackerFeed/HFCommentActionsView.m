//
//  HFCommentActionsView.m
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFCommentActionsView.h"

@implementation HFCommentActionsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
//    NSLog(@"%@", NSStringFromCGRect(self.layer.bounds));
//    self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
//    self.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
//    CATransform3D perspective = CATransform3DIdentity;
//    perspective.m34 = - 1.0 / 500.0;
//    self.layer.transform = CATransform3DMakeRotation(M_PI_2, -1, 0, 0);
}

@end
