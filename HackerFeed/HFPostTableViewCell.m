#import "HFPostTableViewCell.h"

#import "HFLabel.h"
#import "HFRoundedButton.h"

@interface HFPostTableViewCell ()

@end

@implementation HFPostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        self.upvoteButton = [[HFRoundedButton alloc] initWithFrame:CGRectZero];
        [self.upvoteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.upvoteButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.upvoteButton setTitle:@"0" forState:UIControlStateNormal];
        [self.upvoteButton setImage:[[UIImage imageNamed:@"CellUpvoteIconFilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.contentView addSubview:self.upvoteButton];

        self.commentsButton = [[HFRoundedButton alloc] initWithFrame:CGRectZero];
        [self.commentsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.commentsButton setTitle:@"0" forState:UIControlStateNormal];
        [self.commentsButton setImage:[[UIImage imageNamed:@"CommentIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentsButton];

        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.infoLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:self.infoLabel];
        
        self.titleLabel = [[HFLabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.clipsToBounds = YES;
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:self.titleLabel];

        self.moreButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.moreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.moreButton setImage:[[UIImage imageNamed:@"MoreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.moreButton.imageView.tintColor = [[HFInterfaceTheme activeTheme].secondaryTextColor hf_colorLightenedByFactor:0.16f];
        [self.contentView addSubview:self.moreButton];

        [self applyTheme];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_infoLabel]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_infoLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_upvoteButton]-8-[_commentsButton]-(>=8)-[_moreButton(36)]-8-|"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_upvoteButton, _commentsButton, _moreButton)]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_moreButton(36)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_moreButton)]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_infoLabel]-2-[_titleLabel]-8-[_upvoteButton]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_infoLabel, _titleLabel, _upvoteButton)]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Set the max layout width of the multi-line information label to the calculated width of the label after auto layout has run
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
}

- (void)applyTheme {
    [super applyTheme];

    self.infoLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.infoLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleSubheadline];
    self.infoLabel.backgroundColor = self.contentView.backgroundColor;

    self.titleLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
    self.titleLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleHeadline];
    self.titleLabel.backgroundColor = self.contentView.backgroundColor;

    self.upvoteButton.backgroundColor = self.contentView.backgroundColor;
    self.commentsButton.backgroundColor = self.contentView.backgroundColor;
    self.moreButton.backgroundColor = self.contentView.backgroundColor;
}

@end
