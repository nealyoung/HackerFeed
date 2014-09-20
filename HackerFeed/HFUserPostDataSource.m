//
//  HFUserPostDataSource.m
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFUserPostDataSource.h"

#import "libHN.h"
#import "HFPostTableViewCell.h"

static NSString * const kPostTableViewCellIdentifier = @"PostTableViewCell";

@interface HFUserPostDataSource ()

@property NSString *urlAddition;

@end

@implementation HFUserPostDataSource

- (void)refreshWithCompletion:(void (^)(BOOL completed))block {
    if (self.user) {
        [[HNManager sharedManager] fetchSubmissionsForUser:self.user.username completion:^(NSArray *posts) {
            if (posts) {
                self.urlAddition = [HNManager sharedManager].userSubmissionUrlAddition;
                self.posts = [NSMutableArray arrayWithArray:posts];

                block(YES);
            } else {
                block(NO);
            }
        }];
    }
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
