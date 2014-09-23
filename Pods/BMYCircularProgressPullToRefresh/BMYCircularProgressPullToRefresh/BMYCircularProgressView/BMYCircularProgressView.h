//
//  BMYCircularProgressView.h
//  BMYPullToRefreshDemo
//
//  Created by Alberto De Bortoli on 15/05/2014.
//  Copyright (c) 2014 Beamly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMYProgressViewProtocol.h"

@interface BMYCircularProgressView : UIView <BMYProgressViewProtocol>

- (id)initWithFrame:(CGRect)frame
               logo:(UIImage *)logoImage
    backCircleImage:(UIImage *)backCircleImage
   frontCircleImage:(UIImage *)frontCircleImage;

@end
