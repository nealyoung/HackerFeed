//
//  HFCommentToolbar.h
//  HackerFeed
//
//  Created by Nealon Young on 7/27/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFBorderedButton.h"
#import "HFTextView.h"

@interface HFCommentToolbar : UIView

@property (nonatomic) NSString *replyUsername;
@property (nonatomic) UIButton *cancelReplyButton;
@property (nonatomic) HFTextView *textView;
@property (nonatomic) HFBorderedButton *submitButton;

@end
