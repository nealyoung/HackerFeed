//
//  HFPostTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostTableViewCell.h"

#import "HFLabel.h"

@interface HFPostTableViewCell ()

@property UIView *commentButtonBackground;

@end

@implementation HFPostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.infoLabel.textColor = [UIColor darkGrayColor];
        self.infoLabel.font = [UIFont smallCapsApplicationFontWithSize:15.0f];
        [self.contentView addSubview:self.infoLabel];
        
        self.titleLabel = [[HFLabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont applicationFontOfSize:17.0f];
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:self.titleLabel];
        
        self.domainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.domainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.domainLabel.textColor = [UIColor darkGrayColor];
        self.domainLabel.font = [UIFont smallCapsApplicationFontWithSize:15.0f];
        [self.contentView addSubview:self.domainLabel];
        
        self.commentButtonBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [self.commentButtonBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.commentButtonBackground.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
        [self.contentView addSubview:self.commentButtonBackground];
        
        self.commentsButton = [HFCommentsButton buttonWithType:UIButtonTypeCustom];
        [self.commentsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.commentsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentsButton];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_commentButtonBackground]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentButtonBackground)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commentButtonBackground(56)]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentButtonBackground)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_infoLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_infoLabel, _commentsButton)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-12-[_commentsButton(40)]-8-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, _commentsButton)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_domainLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_domainLabel, _commentsButton)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[_infoLabel]-4-[_titleLabel]-4-[_domainLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_infoLabel, _titleLabel, _domainLabel)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.commentsButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:40.0f]];
        
        // Vertically center the comments button
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.commentsButton
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // By default, setHighlighted:animated: makes the backgrounds subviews of the cell's contentView clear, we want to override this behavior so the comment button background does not disappear when the cell is highlighted
    UIColor *commentBackgroundColor = self.commentButtonBackground.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.commentButtonBackground.backgroundColor = commentBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *commentBackgroundColor = self.commentButtonBackground.backgroundColor;
    [super setSelected:selected animated:animated];
    self.commentButtonBackground.backgroundColor = commentBackgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the max layout width of the multi-line information label to the calculated width of the label after auto layout has run
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    
    [self layoutIfNeeded];
}

@end
