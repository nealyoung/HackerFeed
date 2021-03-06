//
//  HFShareExtensionContainerViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 1/19/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "HFNewPostViewController.h"
#import "HFShareExtensionContainerViewController.h"
#import "HFNavigationBar.h"
#import "HFToolbar.h"
#import "ShareViewController.h"

@interface HFShareExtensionContainerViewController ()

- (void)customizeAppearance;

@end

@implementation HFShareExtensionContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeAppearance];
    
    NSExtensionItem *extensionItem = [self.extensionContext.inputItems firstObject];
    NSItemProvider *itemProvider = [extensionItem.attachments firstObject];
    
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
            HNPost *newPost = [[HNPost alloc] init];
            newPost.UrlString = [url absoluteString];
            
            HFNewPostViewController *newPostViewController = [[HFNewPostViewController alloc] initWithNibName:nil bundle:nil];
            newPostViewController.post = newPost;
            UINavigationController *shareNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                              toolbarClass:[HFToolbar class]];
            shareNavigationController.viewControllers = @[newPostViewController];
            
            shareNavigationController.view.frame = self.view.bounds;
            [self.view addSubview:shareNavigationController.view];
            [self addChildViewController:shareNavigationController];
            [shareNavigationController didMoveToParentViewController:self];
        }];
    }
}

/*
 Set up UIAppearance
 */
- (void)customizeAppearance {
    self.view.tintColor = [[HFInterfaceTheme activeTheme] accentColor];
    
    NSDictionary *navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: self.view.tintColor,
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:19.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTitleTextAttributes];
    [[UINavigationBar appearance] setBarTintColor:[[HFInterfaceTheme activeTheme] navigationBarColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSDictionary *barButtonItemTitleTextAttributes = @{NSForegroundColorAttributeName:self.view.tintColor,
                                                       NSFontAttributeName: [UIFont applicationFontOfSize:18.0f]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleTextAttributes forState:UIControlStateNormal];
}

@end
