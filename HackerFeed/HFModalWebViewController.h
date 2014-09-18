//
//  HFModalWebViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 9/13/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFWebViewController.h"

@interface HFModalWebViewController : UINavigationController

@property (readonly) HFWebViewController *webViewController;

- (instancetype)initWithURL:(NSURL *)url;

@end
