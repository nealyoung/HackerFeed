//
//  HFPostTableViewCell.h
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFCommentsButton.h"
#import "HFTableViewCell.h"

@interface HFPostTableViewCell : HFTableViewCell

@property UILabel *infoLabel;
@property UILabel *titleLabel;
@property UILabel *domainLabel;
@property HFCommentsButton *commentsButton;

@end
