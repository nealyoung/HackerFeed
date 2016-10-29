//
//  HNPost+HFAdditions.h
//  HackerFeed
//
//  Created by Nealon Young on 5/1/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

@import Foundation;

#import "libHN.h"

@interface HNPost (HFAdditions)

- (BOOL)isViewed;
- (void)markAsViewed;

@end
