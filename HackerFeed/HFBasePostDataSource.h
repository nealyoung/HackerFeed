@import Foundation;

#import "HFPostListViewController.h"

@interface HFBasePostDataSource : NSObject <HFPostDataSource>

@property NSMutableArray *posts;
@property UIImage *image;

@end
