//
//  HFModalWebViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 9/13/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWebViewController.h"

@interface HFModalWebViewController : UINavigationController

@property (readonly) PBWebViewController *webViewController;

- (instancetype)initWithURL:(NSURL *)url;

@end
