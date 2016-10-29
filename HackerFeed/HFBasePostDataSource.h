//
//  HFBasePostDataSource.h
//  HackerFeed
//
//  Created by Nealon Young on 9/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import Foundation;

#import "HFPostListViewController.h"

@interface HFBasePostDataSource : NSObject <HFPostDataSource>

@property NSMutableArray *posts;
@property UIImage *image;

@end
