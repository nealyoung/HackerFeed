//
//  HFModalWebViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 9/13/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFModalWebViewController.h"

#import "HFNavigationBar.h"

@interface HFModalWebViewController ()

@end

@implementation HFModalWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super initWithNavigationBarClass:[HFNavigationBar class] toolbarClass:nil];
    
    if (self) {
        [self commonInit];
        _webViewController.URL = url;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    _webViewController = [[HFWebViewController alloc] init];
    self.viewControllers = @[_webViewController];
    
    _webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                        target:self
                                                                                                        action:@selector(doneButtonPressed:)];
}

- (void)doneButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
