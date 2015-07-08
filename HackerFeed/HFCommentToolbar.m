//
//  HFCommentToolbar.m
//  HackerFeed
//
//  Created by Nealon Young on 7/27/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFCommentToolbar.h"

@interface HFCommentToolbar ()

@property (nonatomic) UIView *topBorderView;
@property (nonatomic) UIView *replyToView;
@property (nonatomic) UILabel *replyToLabel;
@property (nonatomic) NSLayoutConstraint *replyToViewHeightConstraint;

- (void)applyTheme;

@end

@implementation HFCommentToolbar

- (id)initWithCoder:(NSCoder *)aDecoder {
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
    self.replyToView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.replyToView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.replyToView.hidden = YES;
    [self addSubview:self.replyToView];
    
    self.cancelReplyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelReplyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cancelReplyButton setImage:[UIImage imageNamed:@"CancelIcon"] forState:UIControlStateNormal];
    self.cancelReplyButton.accessibilityLabel = NSLocalizedString(@"Cancel reply", nil);
    self.cancelReplyButton.accessibilityHint = NSLocalizedString(@"Cancels the reply state of the comment being composed", nil);
    [self.replyToView addSubview:self.cancelReplyButton];
    
    self.replyToLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.replyToLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.replyToView addSubview:self.replyToLabel];
    
    self.topBorderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.topBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.topBorderView];
    
    self.textView = [[HFTextView alloc] initWithFrame:CGRectZero];
    [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.textView.layer.cornerRadius = 4.0f;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.scrollEnabled = NO;
    self.textView.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.textView];
    
    self.submitButton = [HFBorderedButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submitButton setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [self addSubview:self.submitButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topBorderView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_topBorderView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_replyToView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_replyToView)]];
    
    [self.replyToView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_cancelReplyButton(24)]-8-[_replyToLabel]-8-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_cancelReplyButton, _replyToLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_textView]-8-[_submitButton(64)]-8-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_textView, _submitButton)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topBorderView(1)]-3.5-[_replyToView]-4-[_textView(>=36)]-8-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_topBorderView, _replyToView, _textView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.replyToLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.replyToView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:-2.0f]];
    
    // Set the initial height of the reply indicator to 0
    self.replyToViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.replyToView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f
                                                                     constant:0.0f];
    [self addConstraint:self.replyToViewHeightConstraint];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelReplyButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.replyToView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_submitButton(36)]-8-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_topBorderView, _submitButton)]];
    
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
}

- (void)applyTheme {
    self.backgroundColor = [[HFInterfaceTheme activeTheme] navigationBarColor];

    self.topBorderView.backgroundColor = [[HFInterfaceTheme activeTheme] accentColor];

    self.replyToLabel.font = [UIFont smallCapsApplicationFontWithSize:15.0f];
    self.replyToLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    
    self.textView.font = [UIFont applicationFontOfSize:15.0f];
    self.textView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorLightenedByFactor:0.1f];
    self.textView.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.textView.layer.borderColor = [[[HFInterfaceTheme activeTheme] accentColor] CGColor];
    
    self.submitButton.titleLabel.font = [UIFont smallCapsApplicationFontWithSize:15.0f];
    self.submitButton.tintColor = [HFInterfaceTheme activeTheme].accentColor;
}

// If set to nil, the 'reply to' indicator will be hidden
- (void)setReplyUsername:(NSString *)replyUsername {
    if (replyUsername) {
        self.replyToViewHeightConstraint.constant = 32;
        
        [UIView animateWithDuration:0.2f animations:^{
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.replyToLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Reply to %@", nil), [replyUsername lowercaseString]];
            self.replyToView.hidden = NO;
        }];
    } else {
        self.replyToView.hidden = YES;
        self.replyToViewHeightConstraint.constant = 0;
        
        [UIView animateWithDuration:0.2f animations:^{
            [self.superview layoutIfNeeded];
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
