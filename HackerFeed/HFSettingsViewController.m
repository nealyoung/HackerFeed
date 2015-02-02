//
//  HFSettingsViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 12/31/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFButtonTableViewCell.h"
#import "HFInterfaceTheme.h"
#import "HFLoginViewController.h"
#import "HFProfileViewController.h"
#import "HFSettingsViewController.h"
#import "HFTableView.h"
#import "HFTableViewCell.h"
#import "libHN.h"

@interface HFSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property UITableView *tableView;

- (void)logoutButtonPressed;

@end

static NSString * const kTableViewCellIdentifier = @"TableViewCell";
static NSString * const kButtonTableViewCellIdentifier = @"ButtonTableViewCell";

static NSInteger const kProfileSection = 0;
static NSInteger const kThemeSection = 1;
static NSInteger const kFontSection = 2;

@implementation HFSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Settings", nil);
        
        self.tableView = [[HFTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.tableView.rowHeight = 44.0f;
        [self.tableView registerClass:[HFTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
        [self.tableView registerClass:[HFButtonTableViewCell class] forCellReuseIdentifier:kButtonTableViewCellIdentifier];
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

- (void)viewDidLoad {
    self.dropdownMenuItem.image = [UIImage imageNamed:@"SettingsIcon"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)logoutButtonPressed {
    if ([HNManager sharedManager].SessionUser) {
        [[HNManager sharedManager] logout];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kProfileSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kProfileSection:
            return NSLocalizedString(@"Account", nil);
            break;
            
        case kFontSection:
            return NSLocalizedString(@"Font", nil);
            break;
            
        case kThemeSection:
            return NSLocalizedString(@"Theme", nil);
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kProfileSection:
            return [HNManager sharedManager].SessionUser ? 2 : 1;
            break;
            
        case kFontSection:
            return [[UIFont availableFontFamilies] count];
            break;
            
        case kThemeSection:
            return [[HFInterfaceTheme allThemes] count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kProfileSection: {
            if ([HNManager sharedManager].SessionUser) {
                if (indexPath.row == 0) {
                    HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
                    
                    cell.textLabel.text = [HNManager sharedManager].SessionUser.Username;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    return cell;
                } else {
                    HFButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonTableViewCellIdentifier forIndexPath:indexPath];
                    
                    [cell.button setTitle:NSLocalizedString(@"Log Out", nil) forState:UIControlStateNormal];
                    [cell.button addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                }
            } else {
                HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
                
                cell.textLabel.text = NSLocalizedString(@"Log In", nil);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }
        }
            
        case kFontSection: {
            HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
            
            cell.textLabel.text = [UIFont availableFontFamilies][indexPath.row];
            
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kFontFamilyDefaultsKey] == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            return cell;
        }
            
        case kThemeSection: {
            HFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
            HFInterfaceTheme *theme = [HFInterfaceTheme allThemes][indexPath.row];
            cell.textLabel.text = theme.title;
            
            if ([HFInterfaceTheme activeTheme].themeType == theme.themeType) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            return cell;
        }
        
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kProfileSection:
            if (indexPath.row == 0) {
                if ([HNManager sharedManager].SessionUser) {
                    HFProfileViewController *profileViewController = [[HFProfileViewController alloc] initWithNibName:nil bundle:nil];
                    profileViewController.user = [HNManager sharedManager].SessionUser;
                    [self.navigationController pushViewController:profileViewController animated:YES];
                } else {
                    HFLoginViewController *loginViewController = [[HFLoginViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:loginViewController animated:YES];
                }
            }
            
            break;
            
        case kFontSection:
            [UIFont setActiveFontFamily:[UIFont availableFontFamilies][indexPath.row]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kFontSection] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case kThemeSection:
            [HFInterfaceTheme setActiveTheme:[HFInterfaceTheme themeWithType:indexPath.row]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kThemeSection] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

@end
