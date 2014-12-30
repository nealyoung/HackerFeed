//
//  HFTextFieldTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 8/1/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFTextFieldTableViewCell.h"
#import "UIFont+HFAdditions.h"

@implementation HFTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
        [self.contentView addSubview:self.titleLabel];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [self.textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = [UIFont applicationFontOfSize:15.0f];
        [self.contentView addSubview:self.textField];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleLabel]-4-[_textField(>=160)]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_titleLabel, _textField)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0.0f]];
    }
    
    return self;
}

- (void)awakeFromNib {
    self.titleLabel.font = [UIFont applicationFontOfSize:16.0f];
    self.textField.font = [UIFont applicationFontOfSize:15.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
