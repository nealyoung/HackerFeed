//
//  HFPostViewController.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import UIKit;

#import "libHN.h"

@interface HFPostViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic) HNPost *post;

@end
