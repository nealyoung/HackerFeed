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
        
        self.upvotesLabel = [[HFUpvotesLabel alloc] initWithFrame:CGRectZero];
        [self.upvotesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.upvotesLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        self.upvotesLabel.text = @"69";
        [self.contentView addSubview:self.upvotesLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.infoLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:self.infoLabel];
        
        self.titleLabel = [[HFLabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:self.titleLabel];
        
        self.domainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.domainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.domainLabel];
        
        self.commentButtonBackground = [[UIView alloc] initWithFrame:CGRectZero];
        [self.commentButtonBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.commentButtonBackground];
        
        self.commentsButton = [HFCommentsButton buttonWithType:UIButtonTypeCustom];
        [self.commentsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.commentsButton.accessibilityLabel = @"Comments";
        self.commentsButton.accessibilityHint = @"Opens article comments";
        [self.contentView addSubview:self.commentsButton];
        
        [self applyTheme];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_commentButtonBackground]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentButtonBackground)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commentButtonBackground(56)]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentButtonBackground)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_upvotesLabel]-8-[_infoLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_upvotesLabel, _infoLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-14-[_commentsButton(44)]-6-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, _commentsButton)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_domainLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_domainLabel, _commentsButton)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_upvotesLabel]-4-[_titleLabel]-4-[_domainLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_upvotesLabel, _titleLabel, _domainLabel)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.upvotesLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.infoLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=4)-[_commentsButton(44)]-(>=4)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentsButton)]];
        
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
    [super setHighlighted:highlighted animated:animated];

    // To improve scrolling performance, the upvotes label is opaque, so we need to set its background color appropriately when the cell is highlighted
    if (!self.upvotesLabel.backgroundHighlighted) {
        if (highlighted) {
            self.upvotesLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.08f];
        } else {
            self.upvotesLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // To improve scrolling performance, the upvotes label is opaque, so we need to set its background color appropriately when the cell is highlighted
    if (!self.upvotesLabel.backgroundHighlighted) {
        if (selected) {
            self.upvotesLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.08f];
        } else {
            self.upvotesLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
        }
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    UIColor *commentBackgroundColor = self.commentButtonBackground.backgroundColor;
//    [super setSelected:selected animated:animated];
//    self.commentButtonBackground.backgroundColor = commentBackgroundColor;
//}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    
//    NSLog(@"set highlighted %d animated %d", highlighted, animated);
//
//    NSTimeInterval animationDuration = animated ? 0.3f : 0.0f;
//    
//    [UIView animateWithDuration:animationDuration animations:^{
//        if (highlighted) {
//            self.titleLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//            self.infoLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//            self.domainLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//        } else {
//            self.titleLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            self.infoLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            self.domainLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//        }
//    }];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    NSLog(@"set selected %d animated %d", selected, animated);
//    
//    if (animated) {
//        [UIView animateWithDuration:0.3f animations:^{
//            if (selected) {
//                self.titleLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//                self.infoLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//                self.domainLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//            } else {
//                self.titleLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                self.infoLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                self.domainLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            }
//        }];
//    } else {
//        if (selected) {
//            self.titleLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//            self.infoLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//            self.domainLabel.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.25f];
//        } else {
//            self.titleLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            self.infoLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            self.domainLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//        }
//    }
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.commentsButton setNeedsLayout];
    
    // Set the max layout width of the multi-line information label to the calculated width of the label after auto layout has run
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
}

- (void)applyTheme {
    [super applyTheme];
    
    self.color1 = [HFInterfaceTheme activeTheme].accentColor;
    
    self.infoLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.infoLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleSubheadline];
//    self.infoLabel.backgroundColor = self.contentView.backgroundColor;

    self.titleLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
    self.titleLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleHeadline];
//    self.titleLabel.backgroundColor = self.contentView.backgroundColor;
    
    self.domainLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.domainLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleSubheadline];
//    self.domainLabel.backgroundColor = self.contentView.backgroundColor;
    
    self.commentButtonBackground.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.02f];
    
    [self.commentsButton setNeedsDisplay];
    [self.commentsButton setTitleColor:[HFInterfaceTheme activeTheme].secondaryTextColor forState:UIControlStateNormal];
    self.commentsButton.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.02f];
}

@end
