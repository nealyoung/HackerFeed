//
//  BMYProgressViewProtocol.h
//  BMYPullToRefreshDemo
//
//  Created by Alberto De Bortoli on 16/05/2014.
//  Copyright (c) 2014 Beamly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMYProgressViewProtocol <NSObject>

@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGRect frame;

- (void)setProgress:(CGFloat)progress;

@end
