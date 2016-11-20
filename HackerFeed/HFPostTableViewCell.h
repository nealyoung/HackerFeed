@import UIKit;

@class HFRoundedButton;

#import "HFTableViewCell.h"
#import "HFUpvotesLabel.h"

@interface HFPostTableViewCell : HFTableViewCell

@property UILabel *infoLabel;
@property UILabel *titleLabel;
@property HFRoundedButton *upvoteButton;
@property HFRoundedButton *commentsButton;
@property UIButton *moreButton;

@end
