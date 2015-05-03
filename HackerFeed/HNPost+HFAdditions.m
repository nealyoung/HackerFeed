//
//  HNPost+HFAdditions.m
//  HackerFeed
//
//  Created by Nealon Young on 5/1/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HNPost+HFAdditions.h"

static NSInteger const kViewedPostLimit = 100;
static NSString * const kViewedPostsDefaultsKey = @"HFViewedPostsDefaultsKey";

@implementation HNPost (HFAdditions)

- (BOOL)isViewed {
    return ([[self viewedPostsArray] indexOfObject:self.PostId] != NSNotFound);
}

- (void)markAsViewed {
    if (![self isViewed]) {
        NSMutableArray *viewedPostsArray = [self viewedPostsArray];
        [viewedPostsArray insertObject:self.PostId atIndex:0];
        
        if ([viewedPostsArray count] > kViewedPostLimit) {
            [viewedPostsArray removeLastObject];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:viewedPostsArray forKey:kViewedPostsDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSMutableArray *)viewedPostsArray {
    NSMutableArray *viewedPostsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kViewedPostsDefaultsKey]];
    
    if (!viewedPostsArray) {
        viewedPostsArray = [NSMutableArray array];
    }
    
    return viewedPostsArray;
}

@end
