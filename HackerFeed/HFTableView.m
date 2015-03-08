//
//  HFTableView.m
//  HackerFeed
//
//  Created by Nealon Young on 2/1/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import "HFTableView.h"

@implementation HFTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)applyTheme {
    self.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.03f];
    self.separatorColor = [HFInterfaceTheme activeTheme].cellSeparatorColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
