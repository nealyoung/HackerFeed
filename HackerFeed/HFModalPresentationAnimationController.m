//
//  HFModalPresentationAnimationController.m
//  HackerFeed
//
//  Created by Nealon Young on 6/21/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFModalPresentationAnimationController.h"

static CGFloat const kDefaultDuration = 0.6f;

@implementation HFModalPresentationAnimationController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.duration = kDefaultDuration;
    }
    
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect initialFrame = [transitionContext finalFrameForViewController:toViewController];
    
    initialFrame.origin.y = -(initialFrame.size.height + initialFrame.origin.y);
    toViewController.view.frame = initialFrame;
    
    [[transitionContext containerView] addSubview:toViewController.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0f
         usingSpringWithDamping:0.76f
          initialSpringVelocity:0.2f
                        options:0
                     animations:^{
                         toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

@end
