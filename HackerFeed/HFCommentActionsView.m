//
//  HFCommentActionsView.m
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFCommentActionsView.h"

@interface HFCommentActionsView ()

@property UIView *bottomBorderView;

@end

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
        self.clipsToBounds = YES;
        self.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.13f];
        
        self.upvoteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.upvoteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.upvoteButton setImage:[UIImage imageNamed:@"UpvoteIcon"] forState:UIControlStateNormal];
        [self addSubview:self.upvoteButton];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.replyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.replyButton setImage:[UIImage imageNamed:@"ReplyIcon"] forState:UIControlStateNormal];
        [self addSubview:self.replyButton];
        
        self.userButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.userButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.userButton setImage:[UIImage imageNamed:@"UserIcon"] forState:UIControlStateNormal];
        [self addSubview:self.userButton];
        
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.bottomBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.bottomBorderView.backgroundColor = [[HFInterfaceTheme activeTheme] accentColor];
        
        [self addSubview:self.bottomBorderView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_upvoteButton(34)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_upvoteButton)]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.upvoteButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.replyButton
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.replyButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_userButton(34)]-20-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_userButton)]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomBorderView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_bottomBorderView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomBorderView(1)]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_bottomBorderView)]];
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
