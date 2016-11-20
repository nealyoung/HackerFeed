@import Foundation;

#import "libHN.h"

@interface HNPost (HFAdditions)

@property (nonatomic, readonly) NSString *shortCreatedAtString;

- (BOOL)isViewed;
- (void)markAsViewed;

@end
