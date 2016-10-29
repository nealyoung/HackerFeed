//
//  HFDropdownMenuTitleView.h
//  HackerFeed
//
//  Created by Nealon Young on 9/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

@import UIKit;

@interface HFDropdownMenuTitleView : UIControl

@property (nonatomic) UILabel *titleLabel;

// Set to YES for downward pointing arrow, default value is NO
@property (nonatomic) BOOL expanded;

@end
