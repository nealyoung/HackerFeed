//
//  HFLoginPopupController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libHN.h"

typedef void (^HFLoginPopupControllerCompletionBlock)(HNUser *user);

@interface HFLoginPopupController : NSObject

@property (nonatomic, strong) HFLoginPopupControllerCompletionBlock loginCompletionBlock;
@property (nonatomic) NSString *message;

- (void)showInViewController:(UIViewController *)viewController;

@end
