//
//  HFFilterPostDataSource.h
//  HackerFeed
//
//  Created by Nealon Young on 7/25/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFPostListViewController.h"

@interface HFFilterPostDataSource : NSObject <HFPostDataSource>

@property PostFilterType postFilterType;
@property NSMutableArray *posts;

- (instancetype)initWithPostFilterType:(PostFilterType)postFilterType;

@end
