//
//  HFFilterPostDataSource.h
//  HackerFeed
//
//  Created by Nealon Young on 7/25/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import Foundation;

#import "HFBasePostDataSource.h"

@interface HFFilterPostDataSource : HFBasePostDataSource

/**
 The libHN post filter type to download
 */
@property PostFilterType postFilterType;

- (instancetype)initWithPostFilterType:(PostFilterType)postFilterType image:(UIImage *)image;

@end
