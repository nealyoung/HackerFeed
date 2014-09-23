//
//  HFBasePostDataSource.m
//  HackerFeed
//
//  Created by Nealon Young on 9/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFBasePostDataSource.h"

@implementation HFBasePostDataSource

- (void)refreshWithCompletion:(void (^)(BOOL))block {
    block(NO);
}

- (void)loadMorePostsWithCompletion:(void (^)(BOOL))block {
    block(NO);
}

@end
