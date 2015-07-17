//
//  HFAlertView.m
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFAlertView.h"

#import "HFAlertAction.h"
#import "HFBorderedButton.h"

@interface HFAlertView ()

@property UIView *contentViewContainerView;
@property (nonatomic) NSArray *actionButtons;

- (void)actionButtonPressed:(HFBorderedButton *)button;

@end

@implementation HFAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.backgroundView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorLightenedByFactor:0.04f];
        self.backgroundView.layer.cornerRadius = 4.0f;
        [self addSubview:_backgroundView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.font = [UIFont semiboldApplicationFontOfSize:18.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
        self.titleLabel.text = NSLocalizedString(@"Title Label", nil);
        [self.backgroundView addSubview:self.titleLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.textLabel setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
        self.textLabel.font = [UIFont applicationFontOfSize:16.0f];
        self.textLabel.text = NSLocalizedString(@"Message Label", nil);
        [self.backgroundView addSubview:self.textLabel];
        
        _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentViewContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.backgroundView addSubview:self.contentViewContainerView];
        
//        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
//        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        [self.contentViewContainerView addSubview:self.contentView];
//        
//        [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
//                                                                                              options:0
//                                                                                              metrics:nil
//                                                                                                views:NSDictionaryOfVariableBindings(_contentView)]];
//        
//        [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
//                                                                                              options:0
//                                                                                              metrics:nil
//                                                                                                views:NSDictionaryOfVariableBindings(_contentView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_backgroundView]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_backgroundView)]];
        //
        //        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView
        //                                                         attribute:NSLayoutAttributeHeight
        //                                                         relatedBy:NSLayoutRelationEqual
        //                                                            toItem:self
        //                                                         attribute:NSLayoutAttributeHeight
        //                                                        multiplier:1.0f
        //                                                          constant:-48.0f]];
        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView
//                                                         attribute:NSLayoutAttributeCenterX
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self
//                                                         attribute:NSLayoutAttributeCenterX
//                                                        multiplier:1.0f
//                                                          constant:0.0f]];
        
        self.backgroundViewVerticalCenteringConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                     multiplier:1.0f
                                                                                       constant:0.0f];
        
        [self addConstraint:self.backgroundViewVerticalCenteringConstraint];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textLabel]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_textLabel)]];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentViewContainerView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_contentViewContainerView)]];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-2-[_textLabel][_contentViewContainerView]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_titleLabel, _textLabel, _contentViewContainerView)]];
    }
    
    return self;
}

// Pass through touches outside the backgroundView for the presentation controller to handle dismissal
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setContentView:(UIView *)contentView {
    [self.contentView removeFromSuperview];
    
    _contentView = contentView;
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentViewContainerView addSubview:self.contentView];
    
    [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self.contentViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(_contentView)]];
}

- (void)actionButtonPressed:(HFBorderedButton *)button {
    HFAlertAction *action = self.actions[button.tag];
    action.handler(action);
}

- (void)setActions:(NSArray *)actions {
    _actions = actions;
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    // Create buttons for each action
    for (int i = 0; i < [actions count]; i++) {
        UIAlertAction *action = actions[i];
        
        HFBorderedButton *button = [[HFBorderedButton alloc] initWithFrame:CGRectZero];
        
        button.tag = i;
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        button.titleLabel.font = [UIFont semiboldApplicationFontOfSize:16.0f];
        [button setTitle:action.title forState:UIControlStateNormal];
        
        if (action.style == UIAlertActionStyleCancel) {
            button.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
        } else {
            button.titleLabel.font = [UIFont semiboldApplicationFontOfSize:16.0f];
        }
        
        if (action.style == UIAlertActionStyleCancel) {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.tintColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
        } else if (action.style == UIAlertActionStyleDestructive) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.tintColor = [UIColor redColor];
        }
        
        [buttons addObject:button];
    }
    
    self.actionButtons = buttons;
}

- (void)setActionButtons:(NSArray *)actionButtons {
    for (UIButton *button  in self.actionButtons) {
        [button removeFromSuperview];
    }
    
    _actionButtons = actionButtons;
    
    // If there are 2 actions, display the buttons next to each other. Otherwise, stack the buttons vertically at full width
    if ([actionButtons count] == 2) {
        UIButton *firstButton = actionButtons[0];
        UIButton *lastButton = actionButtons[1];
        
        [self.backgroundView addSubview:firstButton];
        [self.backgroundView addSubview:lastButton];
        
        [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:firstButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:lastButton
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0f
                                                                         constant:0.0f]];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[firstButton]-[lastButton]-|"
                                                                                    options:NSLayoutFormatAlignAllCenterY
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(firstButton, lastButton)]];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentViewContainerView]-[firstButton(40)]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_contentViewContainerView, firstButton)]];
        
        [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastButton(40)]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(lastButton)]];
    } else {
        for (int i = 0; i < [actionButtons count]; i++) {
            UIButton *actionButton = actionButtons[i];
            
            [self.backgroundView addSubview:actionButton];
            
            [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[actionButton]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(actionButton)]];
            
            [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton(40)]"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(actionButton)]];
            
            if (i == 0) {
                [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentViewContainerView]-[actionButton]"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:NSDictionaryOfVariableBindings(_contentViewContainerView, actionButton)]];
            } else {
                UIButton *previousButton = actionButtons[i - 1];
                
                [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousButton]-[actionButton]"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:NSDictionaryOfVariableBindings(previousButton, actionButton)]];
            }
            
            if (i == ([actionButtons count] - 1)) {
                [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionButton]-|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:NSDictionaryOfVariableBindings(actionButton)]];
            }
        }
    }
}

@end
