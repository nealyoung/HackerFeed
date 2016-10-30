@import UIKit;

#import "HFDropdownMenuItem.h"

@interface HFDropdownMenuButton : UIButton

@property UIImageView *iconImageView;

- (instancetype)initWithItem:(HFDropdownMenuItem *)item;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
