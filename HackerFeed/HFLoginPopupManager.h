//
//  HFLoginPopupManager.h
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

@import UIKit;

#import "libHN.h"

typedef void (^HFLoginPopupManagerCompletionBlock)(HNUser *user);

@interface HFLoginPopupManager : NSObject

@property (nonatomic, strong) HFLoginPopupManagerCompletionBlock loginCompletionBlock;
@property (nonatomic) NSString *message;

- (void)showInViewController:(UIViewController *)viewController;

@end
