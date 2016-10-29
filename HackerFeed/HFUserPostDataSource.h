//
//  HFUserPostDataSource.h
//  HackerFeed
//
//  Created by Nealon Young on 7/26/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import Foundation;

#import "HFBasePostDataSource.h"
#import "HFPostListViewController.h"

@interface HFUserPostDataSource : HFBasePostDataSource

@property HNUser *user;

@end
