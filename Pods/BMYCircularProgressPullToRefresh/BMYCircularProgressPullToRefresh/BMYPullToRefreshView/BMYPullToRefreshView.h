//
//  BMYPullToRefreshView.h
//  BMYPullToRefreshDemo
//
//  Created by Alberto De Bortoli on 15/05/2014.
//  Copyright (c) 2014 Beamly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMYProgressViewProtocol.h"

typedef NS_ENUM(NSUInteger, BMYPullToRefreshState) {
    BMYPullToRefreshStateStopped = 0,
    BMYPullToRefreshStateTriggered,
    BMYPullToRefreshStateLoading,
    BMYPullToRefreshStateAll = 10
};

@interface BMYPullToRefreshView : UIView

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(BMYPullToRefreshView *pullToRefreshView);
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) BMYPullToRefreshState state;
@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor;
@property (nonatomic, assign, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, assign) BOOL preserveContentInset;

- (instancetype)initWithHeight:(CGFloat)height scrollView:(UIScrollView *)scrollView;

- (void)setProgressView:(UIView<BMYProgressViewProtocol> *)view;

- (void)startAnimating;
- (void)stopAnimating;

@end
