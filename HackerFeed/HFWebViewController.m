//
//  HFWebViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 9/18/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFWebViewController.h"

#import "FCOpenInSafariActivity.h"

@interface HFWebViewController ()

@end

@implementation HFWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FCOpenInSafariActivity *openInSafariActivity = [FCOpenInSafariActivity new];
        
        self.applicationActivities = @[openInSafariActivity];
    }
    return self;
}

@end
