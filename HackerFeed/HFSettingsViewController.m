//
//  HFSettingsViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 12/31/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFSettingsViewController.h"
#import "HFTableViewCell.h"

@interface HFSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property UITableView *tableView;

@end

static NSString * const kTableViewCellIdentifier = @"TableViewCell";

@implementation HFSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Settings", nil);
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.tableView registerClass:[HFTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Font", nil);
            break;
            
        case 1:
            return NSLocalizedString(@"Theme", nil);
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
            
        case 1:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Source Sans Pro";
            } else {
                cell.textLabel.text = @"Avenir Next";
            }
            
            return cell;
        }
            
        case 1: {
            HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"Theme %ld", (long)indexPath.row];
            return cell;
        }
        
        default:
            return nil;
            break;
    }
    
    HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Theme %ld", (long)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [UIColor hf_setCurrentColorTheme:indexPath.row];
            break;
            
        case 1:
            [UIColor hf_setCurrentColorTheme:indexPath.row];
            break;
    }
}

@end
