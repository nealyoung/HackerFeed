//
//  HFPostListViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import UIKit;

#import "HFTableView.h"
#import "libHN.h"

@protocol HFPostDataSource <NSObject>

@property UIImage *image;
@property NSArray *posts;

- (void)refreshWithCompletion:(void (^)(BOOL completed))block;
- (void)loadMorePostsWithCompletion:(void (^)(BOOL completed))block;

@end

@interface HFPostListViewController : UIViewController

@property HFTableView *tableView;

@property (nonatomic) id <HFPostDataSource> dataSource;

@end
