//
//  HFTextViewTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 8/1/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFTextViewTableViewCell.h"
#import "UIFont+HFAdditions.h"

@implementation HFTextViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textView = [[HFTextView alloc] initWithFrame:CGRectZero];
        [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.textView.scrollEnabled = NO;
        self.textView.editable = NO;
        self.textView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
        self.textView.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
        self.textView.font = [UIFont applicationFontOfSize:15.0f];
        [self.contentView addSubview:self.textView];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_textView]-10-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_textView)]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[_textView]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_textView)]];
    }
    
    return self;
}

@end
