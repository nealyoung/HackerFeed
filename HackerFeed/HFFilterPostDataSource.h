@import Foundation;

#import "HFBasePostDataSource.h"

@interface HFFilterPostDataSource : HFBasePostDataSource

/**
 The libHN post filter type to download
 */
@property PostFilterType postFilterType;

- (instancetype)initWithPostFilterType:(PostFilterType)postFilterType image:(UIImage *)image;

@end
