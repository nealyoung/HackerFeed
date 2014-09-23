//
//  UIScrollView+BMYPullToRefresh.m
//  BMYPullToRefreshDemo
//
//  Created by Alberto De Bortoli on 15/05/2014.
//  Copyright (c) 2014 Beamly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMYPullToRefreshView.h"

@class BMYPullToRefreshView;

@interface UIScrollView (BMYPullToRefresh)

@property (nonatomic, strong, readonly) BMYPullToRefreshView *pullToRefreshView;

- (void)setPullToRefreshWithHeight:(CGFloat)height
                     actionHandler:(void (^)(BMYPullToRefreshView *pullToRefreshView))actionHandler;

- (void)tearDownPullToRefresh;

@end
