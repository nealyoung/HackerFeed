//
//  HFProfileViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/21/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFProfileViewController.h"

#import "HFLoginViewController.h"
#import "HFUserInfoTableViewCell.h"
#import "HFUserPostDataSource.h"
#import "HFPostListViewController.h"
#import "HFTextViewTableViewCell.h"
#import "HFTableViewCell.h"

@interface HFProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@end

static NSString * const kTextViewTableViewCellIdentifier = @"TextViewTableViewCell";
static NSString * const kUserInfoTableViewCellIdentifier = @"UserInfoTableViewCell";
static NSString * const kUserKarmaTableViewCellIdentifier = @"UserKarmaTableViewCell";
static NSString * const kUserSubmissionsTableViewCellIdentifier = @"UserSubmissionsTableViewCell";

@implementation HFProfileViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.title = NSLocalizedString(@"Profile", nil);
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Profile", nil);
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    [super viewDidLoad];
    
    [self.tableView registerClass:[HFUserInfoTableViewCell class] forCellReuseIdentifier:kUserInfoTableViewCellIdentifier];
    [self.tableView registerClass:[HFTextViewTableViewCell class] forCellReuseIdentifier:kTextViewTableViewCellIdentifier];
    [self.tableView registerClass:[HFTableViewCell class] forCellReuseIdentifier:kUserKarmaTableViewCellIdentifier];
    [self.tableView registerClass:[HFTableViewCell class] forCellReuseIdentifier:kUserSubmissionsTableViewCellIdentifier];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setUser:(HNUser *)user {
    _user = user;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.user) {
        return 0;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // Don't show a cell for the user's bio if they don't have one
        return [self.user.AboutInfo length] > 0 ? 3 : 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HFUserInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUserInfoTableViewCellIdentifier
                                                                                  forIndexPath:indexPath];
            cell.usernameLabel.text = self.user.Username;
            cell.ageLabel.text = [NSString stringWithFormat:@"user for %d days", self.user.Age];

            return cell;
        } else if (indexPath.row == 1) {
            HFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUserKarmaTableViewCellIdentifier
                                                                         forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"Karma", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.user.Karma];
            
            return cell;
        } else {
            HFTextViewTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextViewTableViewCellIdentifier
                                                                                  forIndexPath:indexPath];
            cell.textView.text = self.user.AboutInfo;

            return cell;
        }
    } else {
        HFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUserSubmissionsTableViewCellIdentifier
                                                                     forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"Submissions", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 58.0f;
        } else if (indexPath.row == 1) {
            return 40.0f;
        } else {
            static HFTextViewTableViewCell *textViewMetricsCell;
            
            if (!textViewMetricsCell) {
                textViewMetricsCell = [[HFTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            }
            
            textViewMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
            
            textViewMetricsCell.textView.text = self.user.AboutInfo;
            [textViewMetricsCell setNeedsLayout];
            [textViewMetricsCell layoutIfNeeded];
            
            // Get the actual height required for the cell
            CGFloat height = [textViewMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
            
            // Add an extra point to the height to account for the cell separator, which is added between the bottom of the cell's contentView and the bottom of the table view cell.
            height += 1;
            
            return height;
        }
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        HFPostListViewController *postListViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                       bundle:nil] instantiateViewControllerWithIdentifier:@"PostListViewController"];
        HFUserPostDataSource *postDataSource = [HFUserPostDataSource new];
        postDataSource.user = self.user;
        postListViewController.dataSource = postDataSource;
        
        // Don't show the new post icon when viewing a user's submissions
        postListViewController.navigationItem.rightBarButtonItem = nil;
        
        [self.navigationController pushViewController:postListViewController animated:YES];
    }
}

@end
