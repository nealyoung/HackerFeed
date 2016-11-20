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

- (NSString *)shortCreatedAtString {
    NSMutableString *mutableCreatedAtString = [self.TimeCreatedString mutableCopy];

    if ([mutableCreatedAtString rangeOfString:@" minute ago"].location != NSNotFound) {
        [mutableCreatedAtString replaceCharactersInRange:[mutableCreatedAtString rangeOfString:@" minute ago"] withString:@"m"];
    } else if ([mutableCreatedAtString rangeOfString:@" minutes ago"].location != NSNotFound) {
        [mutableCreatedAtString replaceCharactersInRange:[mutableCreatedAtString rangeOfString:@" minutes ago"] withString:@"m"];
    } else if ([mutableCreatedAtString rangeOfString:@" hour ago"].location != NSNotFound) {
        [mutableCreatedAtString replaceCharactersInRange:[mutableCreatedAtString rangeOfString:@" hour ago"] withString:@"h"];
    } else if ([mutableCreatedAtString rangeOfString:@" hours ago"].location != NSNotFound) {
        [mutableCreatedAtString replaceCharactersInRange:[mutableCreatedAtString rangeOfString:@" hours ago"] withString:@"h"];
    }

    return [NSString stringWithString:mutableCreatedAtString];
}

@end
