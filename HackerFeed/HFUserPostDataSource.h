//
//  HFUserPostDataSource.h
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFPostListViewController.h"

@interface HFUserPostDataSource : NSObject <HFPostDataSource>

@property HNUser *user;
@property NSMutableArray *posts;

@end
