//
//  HFFilterPostDataSource.m
//  HackerFeed
//
//  Created by Nealon Young on 7/25/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFFilterPostDataSource.h"

@interface HFFilterPostDataSource ()

@property NSString *urlAddition;

@end

@implementation HFFilterPostDataSource

- (instancetype)initWithPostFilterType:(PostFilterType)postFilterType {
    self = [super init];
    
    if (self) {
        self.postFilterType = postFilterType;
    }
    
    return self;
}

- (void)refreshWithCompletion:(void (^)(BOOL completed))block {
    [[HNManager sharedManager] loadPostsWithFilter:self.postFilterType completion:^(NSArray *posts) {
        if (posts) {
            self.urlAddition = [HNManager sharedManager].postUrlAddition;
            self.posts = [NSMutableArray arrayWithArray:posts];
            block(YES);
        } else {
            block(NO);
        }
    }];
}

- (void)loadMorePostsWithCompletion:(void (^)(BOOL completed))block {
    if (self.urlAddition) {
        [[HNManager sharedManager] loadPostsWithUrlAddition:self.urlAddition completion:^(NSArray *posts) {
            [self.posts addObjectsFromArray:posts];
            block(YES);
        }];
    } else {
        [self refreshWithCompletion:block];
    }
}

@end
