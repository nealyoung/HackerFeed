//
//  HFAlertView.h
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFAlertView : UIView

@property (nonatomic) CGFloat maximumWidth;

@property UILabel *titleLabel;
@property UILabel *textLabel;
@property (nonatomic) UIView *contentView;

@property UIView *backgroundView;

@property NSLayoutConstraint *backgroundViewVerticalCenteringConstraint;

@property (nonatomic) NSArray *actions;

@end
