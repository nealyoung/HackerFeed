//
//  HFModalPresentationManager.m
//  HackerFeed
//
//  Created by Nealon Young on 6/21/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFModalPresentationManager.h"

#import "HFModalDismissalAnimationController.h"
#import "HFModalPresentationAnimationController.h"
#import "HFModalPresentationController.h"

@implementation HFModalPresentationManager

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    return [[HFModalPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return [[HFModalPresentationAnimationController alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    HFModalDismissalAnimationController *animationController = [[HFModalDismissalAnimationController alloc] init];
    return animationController;
}

@end
