//
//  HFCommentTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFCommentTableViewCell.h"

#import "HFAttributedLabel.h"
#import "HFTextView.h"

@interface HFCommentTableViewCell ()

// The state of the cell's separator needs to be saved before expanding the cell and hiding the separator so it can be restored once the cell is contracted
@property UIEdgeInsets savedSeparatorInset;

@end

@implementation HFCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.usernameLabel];
        
//        self.textView = [[HFTextView alloc] initWithFrame:CGRectZero];
//        [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.textView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        self.textView.editable = NO;
////        self.textView.opaque = YES;
//        self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
//        [self.contentView addSubview:self.textView];
        
        self.commentLabel = [[HFAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.commentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.commentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.commentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        self.commentLabel.font = [UIFont applicationFontOfSize:14.0f];
        [self.contentView addSubview:self.commentLabel];
        
        self.commentActionsView = [[HFCommentActionsView alloc] initWithFrame:CGRectZero];
        [self.commentActionsView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.commentActionsView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:self.commentActionsView];
        
        self.usernameLabelLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.usernameLabel
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.contentView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f
                                                                            constant:15.0f];
        [self.contentView addConstraint:self.usernameLabelLeadingConstraint];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_usernameLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_usernameLabel)]];
        
        self.commentLabelLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.commentLabel
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0f
                                                                       constant:15.0f];
        [self.contentView addConstraint:self.commentLabelLeadingConstraint];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commentLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentActionsView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_commentActionsView)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[_usernameLabel][_commentLabel]-8-[_commentActionsView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_usernameLabel, _commentLabel, _commentActionsView)]];
        
        self.toolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.commentActionsView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:0.0f];
        [self.contentView addConstraint:self.toolbarHeightConstraint];
        
        [self applyTheme];
    }
    
    return self;
}

- (void)applyTheme {
    [super applyTheme];
    
    self.usernameLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
    self.usernameLabel.font = [UIFont smallCapsApplicationFontWithSize:15.0f];
    
//    self.textView.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
//    self.textView.font = [UIFont applicationFontOfSize:14.0f];
    
    self.commentLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.commentLabel.font = [UIFont applicationFontOfSize:14.0f];
}

- (void)awakeFromNib {
//    self.textView.font = [UIFont applicationFontOfSize:14.0f];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

- (void)setExpanded:(BOOL)expanded {
    [self setExpanded:expanded animated:YES];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    _expanded = expanded;
    
    if (expanded) {
        if (UIEdgeInsetsEqualToEdgeInsets(self.savedSeparatorInset, UIEdgeInsetsZero)) {
            self.savedSeparatorInset = self.separatorInset;
        }
        
        self.separatorInset = UIEdgeInsetsMake(0.0f, CGRectGetWidth(self.frame), 0.0f, 0.0f);
        self.commentActionsView.hidden = NO;
        self.toolbarHeightConstraint.constant = 40.0f;
    } else {
        self.separatorInset = self.savedSeparatorInset;
        self.savedSeparatorInset = UIEdgeInsetsZero;
        self.toolbarHeightConstraint.constant = 0.0f;
    }
    
    [self setNeedsUpdateConstraints];
    
    /*
     To improve scrolling performance, we want to make the background color of the text views opaque. However, the backgroundColor property of UITextView is not animatable, so we need to make the text view's background transparent when the cell is expanded and the animation between the expanded/unexpanded colors needs to be visible. When expanded is set to NO, the text view's background is again made opaque after completing any animations.
     */
    if (expanded) {
        self.commentLabel.backgroundColor = [UIColor clearColor];
//        self.textView.backgroundColor = [UIColor clearColor];
//        for (UIView *subview in self.textView.subviews) {
//            subview.backgroundColor = [UIColor clearColor];
//        }
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutIfNeeded];
            
            if (expanded) {
                self.contentView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.03f];
            } else {
                self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
            }
        } completion:^(BOOL finished) {
            if (!expanded) {
                self.commentActionsView.hidden = YES;
                
                self.commentLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                self.textView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                for (UIView *subview in self.textView.subviews) {
//                    subview.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                }
            }
        }];
    } else {
        [self layoutIfNeeded];
        
        if (expanded) {
            self.contentView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.03f];
        } else {
            self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
            self.commentLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;

//            self.textView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            for (UIView *subview in self.textView.subviews) {
//                subview.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            }
            
            self.commentActionsView.hidden = YES;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentTableViewCellTapped:)]) {
        [self.delegate commentTableViewCellTapped:self];
    }
}

@end
