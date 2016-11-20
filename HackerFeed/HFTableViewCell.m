//
//  HFTableViewCell.m
//  HackerFeed
//
//  Created by Nealon Young on 8/5/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFTableViewCell.h"

@implementation HFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [self setSelected:highlighted animated:animated];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    UIColor *selectedBackgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.08f];
//    
//    if (animated) {
//        [UIView animateWithDuration:0.3f animations:^{
//            if (selected && self.selectionStyle != UITableViewCellSelectionStyleNone) {
//                self.textLabel.backgroundColor = selectedBackgroundColor;
//                self.backgroundColor = selectedBackgroundColor;
//                self.contentView.backgroundColor = selectedBackgroundColor;
//            } else {
//                self.textLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                self.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//                self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            }
//        } completion:^(BOOL finished) {
//            NSLog(@"COMPLETED");
//        }];
//    } else {
//        if (selected && self.selectionStyle != UITableViewCellSelectionStyleNone) {
//            self.textLabel.backgroundColor = selectedBackgroundColor;
//            self.backgroundColor = selectedBackgroundColor;
//            self.contentView.backgroundColor = selectedBackgroundColor;
//        } else {
//            self.textLabel.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            self.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//            self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
//        }
//    }
//}

- (void)selectionAnimationFinished {

}

- (void)applyTheme {
    self.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
    self.contentView.backgroundColor = [HFInterfaceTheme activeTheme].backgroundColor;
        
    self.textLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleHeadline];
    self.textLabel.textColor = [HFInterfaceTheme activeTheme].textColor;

    self.detailTextLabel.font = [UIFont preferredApplicationFontForTextStyle:UIFontTextStyleSubheadline];
    self.detailTextLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    
    [self setNeedsLayout];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
