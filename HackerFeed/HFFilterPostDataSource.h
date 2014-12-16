//
//  HFFilterPostDataSource.h
//  HackerFeed
//
//  Created by Nealon Young on 7/25/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFBasePostDataSource.h"

@interface HFFilterPostDataSource : HFBasePostDataSource

@property PostFilterType postFilterType;

- (instancetype)initWithPostFilterType:(PostFilterType)postFilterType image:(UIImage *)image;

@end
