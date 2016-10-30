@import UIKit;

#import "HFBorderedButton.h"
#import "HFTextView.h"

@interface HFCommentToolbar : UIView

@property (nonatomic) NSString *replyUsername;
@property (nonatomic) UIButton *cancelReplyButton;
@property (nonatomic) HFTextView *textView;
@property (nonatomic) HFBorderedButton *submitButton;

@end
