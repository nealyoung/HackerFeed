//
//  HFPullToRefreshContentView.h
//  HackerFeed
//
//  Created by Nealon Young on 1/31/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "DACircularProgressView.h"
#import "HFPullToRefreshContentView.h"

@interface HFPullToRefreshContentView ()

@property UIActivityIndicatorView *activityIndicatorView;
@property DACircularProgressView *circularProgressView;

- (void)applyTheme;

@end

@implementation HFPullToRefreshContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_activityIndicatorView];
        
        _circularProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectZero];
        [_circularProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _circularProgressView.thicknessRatio = 0.2f;
        [self addSubview:_circularProgressView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0f
                                                          constant:30.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0f
                                                          constant:30.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_circularProgressView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0f
                                                          constant:30.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_circularProgressView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0f
                                                          constant:30.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_circularProgressView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_circularProgressView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (void)applyTheme {
    if ([HFInterfaceTheme activeTheme].themeType == HFInterfaceThemeTypeBlue) {
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    } else {
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    self.circularProgressView.trackTintColor = [UIColor clearColor];
    self.circularProgressView.progressTintColor = [HFInterfaceTheme activeTheme].accentColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

#pragma mark - SSPullToRefreshContentView

- (void)setPullProgress:(CGFloat)pullProgress {
    self.circularProgressView.progress = pullProgress;
}

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
    switch (state) {
        case SSPullToRefreshViewStateReady: {
            self.circularProgressView.alpha = 1.0f;
            
            [self.activityIndicatorView startAnimating];
            self.activityIndicatorView.alpha = 0.0f;
            break;
        }
            
        case SSPullToRefreshViewStateNormal: {
            self.circularProgressView.alpha = 1.0f;

            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0f;
            break;
        }
            
        case SSPullToRefreshViewStateLoading: {
            self.circularProgressView.alpha = 0.0f;
            
            [self.activityIndicatorView startAnimating];
            self.activityIndicatorView.alpha = 1.0f;
            break;
        }
            
        case SSPullToRefreshViewStateClosing: {
            self.activityIndicatorView.alpha = 0.0f;
            break;
        }
    }
}

@end
