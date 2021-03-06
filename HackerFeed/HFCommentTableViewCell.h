//
//  HFCommentTableViewCell.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFCommentActionsView.h"
#import "HFTableViewCell.h"
#import "HFTextView.h"
#import "TTTAttributedLabel.h"

@class HFCommentTableViewCell;

@protocol HFCommentTableViewCellDelegate <NSObject>

- (void)commentTableViewCellTapped:(HFCommentTableViewCell *)cell;

@end

@interface HFCommentTableViewCell : HFTableViewCell

@property (weak) id <HFCommentTableViewCellDelegate> gestureDelegate;

@property (nonatomic) BOOL expanded;

@property UILabel *usernameLabel;
//@property HFTextView *textView;
@property TTTAttributedLabel *commentLabel;
@property NSLayoutConstraint *usernameLabelLeadingConstraint;
@property NSLayoutConstraint *commentLabelLeadingConstraint;
@property NSLayoutConstraint *toolbarHeightConstraint;

@property HFCommentActionsView *commentActionsView;

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

@end
