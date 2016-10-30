#import "HFBasePostDataSource.h"

@implementation HFBasePostDataSource

- (void)refreshWithCompletion:(void (^)(BOOL))block {
    block(NO);
}

- (void)loadMorePostsWithCompletion:(void (^)(BOOL))block {
    block(NO);
}

@end
