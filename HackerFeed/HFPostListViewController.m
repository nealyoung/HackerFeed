//
//  HFPostListViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostListViewController.h"

#import "DMScaleTransition.h"
#import "HFAlertViewController.h"
#import "HFLoginPopupManager.h"
#import "HFModalPresentationManager.h"
#import "HFModalWebViewController.h"
#import "HFNavigationBar.h"
#import "HFNewPostViewController.h"
#import "HFPostTableViewCell.h"
#import "HFPostViewController.h"
#import "HFPullToRefreshContentView.h"
#import "HFToolbar.h"
#import "HFWebViewController.h"
#import "HNPost+HFAdditions.h"
#import "SSPullToRefresh.h"
#import "SVProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface HFPostListViewController () <SSPullToRefreshViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property DMScaleTransition *scaleTransition;
@property SSPullToRefreshView *pullToRefreshView;

@property (nonatomic) HFLoginPopupManager *loginPopupController;
@property (nonatomic) HFModalPresentationManager *modalPresentationManager;

- (void)applyTheme;
- (void)refresh;

- (void)cellSwiped:(MCSwipeTableViewCell *)cell;
- (void)commentsButtonPressed:(UIButton *)button;
- (void)newPostButtonPressed;

@end

static NSString * const kPostTableViewCellIdentifier = @"PostTableViewCell";

@implementation HFPostListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tableView = [[HFTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.tableView.rowHeight = 72.0f;
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        //self.tableView.estimatedRowHeight = 80.0f;
        [self.tableView registerClass:[HFPostTableViewCell class] forCellReuseIdentifier:kPostTableViewCellIdentifier];
        [self.view addSubview:self.tableView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreatePostIcon"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(newPostButtonPressed)];
        self.navigationItem.rightBarButtonItem.accessibilityLabel = NSLocalizedString(@"New post", nil);
        self.navigationItem.rightBarButtonItem.accessibilityHint = NSLocalizedString(@"Displays the new post page", nil);
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kThemeChangedNotificationName
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [self applyTheme];
                                                      }];
    }
    
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // We set the table view's dataSource/delegate here to avoid auto layout errors - otherwise, the height calculation on cells is run even if a view hasn't been laid out yet (the non-default post lists in the dropdown menu). At that point, the width of the table view's frame is 0, so auto layout is unable to satisfy the metrics cell's constraints.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (!self.pullToRefreshView) {
        self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
        self.pullToRefreshView.contentView = [[HFPullToRefreshContentView alloc] initWithFrame:CGRectZero];
    }
    
    __weak typeof(self) welf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [welf loadMorePosts];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.dataSource.posts) {
        [self refresh];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

- (HFLoginPopupManager *)loginPopupController {
    if (!_loginPopupController) {
        _loginPopupController = [[HFLoginPopupManager alloc] init];
    }
    
    return _loginPopupController;
}

- (HFModalPresentationManager *)modalPresentationManager {
    if (!_modalPresentationManager) {
        _modalPresentationManager = [[HFModalPresentationManager alloc] init];
    }
    
    return _modalPresentationManager;
}

- (void)refresh {
    [self.dataSource refreshWithCompletion:^(BOOL completed) {
        if (completed) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Could not load posts", nil)];
        }
        
        [self.pullToRefreshView finishLoading];
    }];
}

- (void)loadMorePosts {
    [self.dataSource loadMorePostsWithCompletion:^(BOOL completed) {
        if (completed) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Could not load posts", nil)];
            self.tableView.showsInfiniteScrolling = NO;
        }
        
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)applyTheme {
    self.tableView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.03f];
    self.tableView.separatorColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.06f];
}

- (void)cellSwiped:(MCSwipeTableViewCell *)cell {
    NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
    HNPost *post = self.dataSource.posts[cellIndexPath.row];
    
    if (![HNManager sharedManager].SessionUser) {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You must be signed in to vote", nil)];
        
        [self.loginPopupController showInViewController:self];
        
//        HFAlertViewController *alertViewController = [[HFAlertViewController alloc] initWithNibName:nil bundle:nil];
//        alertViewController.title = NSLocalizedString(@"Log In", nil);
//        alertViewController.message = NSLocalizedString(@"You must be signed in to vote", nil);
//        
//        [alertViewController addAction:[HFAlertAction actionWithTitle:NSLocalizedString(@"Sign In", nil) style:UIAlertActionStyleDefault handler:^(HFAlertAction *action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }]];
//        
//        [alertViewController addAction:[HFAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(HFAlertAction *action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }]];
//        
//        alertViewController.modalPresentationStyle = UIModalPresentationCustom;
//        alertViewController.transitioningDelegate = self.modalPresentationManager;
//        
//        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
//        
//        UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
//        [usernameTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
//        usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
//        usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//        usernameTextField.returnKeyType = UIReturnKeyNext;
//        usernameTextField.font = [UIFont applicationFontOfSize:14.0f];
//        usernameTextField.placeholder = NSLocalizedString(@"Username", nil);
//        [contentView addSubview:usernameTextField];
//        
//        UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
//        [passwordTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
//        passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
//        passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//        passwordTextField.returnKeyType = UIReturnKeyNext;
//        passwordTextField.secureTextEntry = YES;
//        passwordTextField.font = [UIFont applicationFontOfSize:14.0f];
//        passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
//        [contentView addSubview:passwordTextField];
//        
//        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[usernameTextField]-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:NSDictionaryOfVariableBindings(usernameTextField)]];
//        
//        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[passwordTextField]-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:NSDictionaryOfVariableBindings(passwordTextField)]];
//        
//        [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[usernameTextField]-[passwordTextField]-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:NSDictionaryOfVariableBindings(usernameTextField, passwordTextField)]];
//        
//        alertViewController.alertViewContentView = contentView;
//        
//        [self presentViewController:alertViewController animated:YES completion:nil];
        
        return;
    }
    
    if (![[HNManager sharedManager] hasVotedOnObject:post]) {
        [[HNManager sharedManager] voteOnPostOrComment:post direction:VoteDirectionUp completion:^(BOOL success) {
            if (!success) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error upvoting post", nil)];
                return;
            }
            
            post.Points++;
            
            HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:cellIndexPath];
            
            // Make sure the cell is still visible
            if (cell) {
                // Reload the cell so the points label reflects the user's upvote
                [self configureCell:cell forPost:post];
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:0
                                 animations:^{
                                     cell.upvotesLabel.layer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0f);
                                 }
                                 completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.3f
                                                           delay:0.0f
                                                         options:0
                                                      animations:^{
                                                          cell.upvotesLabel.layer.transform = CATransform3DIdentity;
                                                      }
                                                      completion:nil];
                                 }];
            }
        }];
    }
}

- (void)commentsButtonPressed:(HFCommentsButton *)sender {
    UINavigationController *postNavigationController;
    HFPostViewController *postViewController;
    
    // If the split view controller is displaying the post list VC and the post VC, we can access the visible post VC through the viewControllers property of UISplitViewcontroller. Otherwise, we need to instantiate and display a new post VC to show comments
    if ([self.splitViewController.viewControllers count] == 2) {
        postNavigationController = [self.splitViewController.viewControllers lastObject];
        postViewController = [postNavigationController.viewControllers firstObject];
    } else {
        postViewController = [[HFPostViewController alloc] initWithNibName:nil bundle:nil];
        self.splitViewController.delegate = postViewController;
        
        postNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                 toolbarClass:[HFToolbar class]];
        postNavigationController.viewControllers = @[postViewController];
    }
    
    HFCommentsButton *commentsButton = (HFCommentsButton *)sender;
    HNPost *post = self.dataSource.posts[commentsButton.tag];
    postViewController.post = post;
    
    [post markAsViewed];
    
    // Reconfigure the cell so the title color immediately reflects the link's read state
    HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [self configureCell:cell forPost:post];
    
    [self showDetailViewController:postNavigationController sender:self];
}

- (void)newPostButtonPressed {
    HFNewPostViewController *newPostViewController = [[HFNewPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                 toolbarClass:[HFToolbar class]];
    navigationController.viewControllers = @[newPostViewController];
    
    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    } else {
//        self.scaleTransition = [DMScaleTransition new];
//        navigationController.transitioningDelegate = self.scaleTransition;
        navigationController.modalPresentationStyle = UIModalPresentationCustom;

        navigationController.transitioningDelegate = self.modalPresentationManager;
    }
    
    [self.splitViewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Getters/Setters

- (void)setDataSource:(id<HFPostDataSource>)dataSource {
    _dataSource = dataSource;
    self.dropdownMenuItem.image = dataSource.image;
    
    //[self refresh];
}

#pragma mark - SSPullToRefreshDelegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFPostTableViewCell *postTableViewCell = [tableView dequeueReusableCellWithIdentifier:kPostTableViewCellIdentifier forIndexPath:indexPath];
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    [self configureCell:postTableViewCell forPost:post];
    
    return postTableViewCell;
}

- (void)configureCell:(HFPostTableViewCell *)cell forPost:(HNPost *)post {
    cell.titleLabel.text = post.Title;
    
    if ([post isViewed]) {
        cell.titleLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    } else {
        cell.titleLabel.textColor = [HFInterfaceTheme activeTheme].textColor;
    }
    
    cell.domainLabel.text = post.UrlDomain;
    cell.commentsButton.tag = [self.dataSource.posts indexOfObject:post];
    
    if (post.Type == PostTypeJobs) {
        cell.commentsButton.enabled = NO;
        cell.upvotesLabel.hidden = YES;
        cell.upvotesLabel.text = nil;
        cell.infoLabel.text = nil;
        [cell.commentsButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        cell.commentsButton.enabled = YES;
        cell.upvotesLabel.hidden = NO;
        
        if ([[HNManager sharedManager] hasVotedOnObject:post]) {
            cell.upvotesLabel.backgroundHighlighted = YES;
        } else {
            cell.upvotesLabel.backgroundHighlighted = NO;
        }
        
        cell.upvotesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d", nil), post.Points];
        cell.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ · %@", nil), [post.Username lowercaseString], post.TimeCreatedString];
        [cell.commentsButton addTarget:self action:@selector(commentsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (post.CommentCount >= 1000) {
            [cell.commentsButton setTitle:@"1k+" forState:UIControlStateNormal];
        } else {
            [cell.commentsButton setTitle:[NSString stringWithFormat:@"%d", post.CommentCount] forState:UIControlStateNormal];
        }
    }
    
    cell.defaultColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.08f];
    
    UIImageView *upvoteIconImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BarButtonUpvoteIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    upvoteIconImageView.tintColor = [UIColor whiteColor];
    
    // Add upvote swipe gesture, except for job posts (as they can't be upvoted), swipe gestures are removed in MCSwipeTableViewCell's prepareForReuse, so we have to re-add it here
    if (post.Type != PostTypeJobs) {
        [cell setSwipeGestureWithView:upvoteIconImageView
                                color:[HFInterfaceTheme activeTheme].accentColor
                                 mode:MCSwipeTableViewCellModeSwitch
                                state:MCSwipeTableViewCellState1
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          [self cellSwiped:cell];
                      }];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static HFPostTableViewCell *postMetricsCell;
    
    if (!postMetricsCell) {
        postMetricsCell = [[HFPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    postMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    [self configureCell:postMetricsCell forPost:post];
    
    [postMetricsCell setNeedsLayout];
    [postMetricsCell layoutIfNeeded];
    
    CGSize size = [postMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    CGFloat cellHeight = size.height + 1;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    [post markAsViewed];
    
    HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // Reconfigure the cell so the title color immediately reflects the link's read state
    [self configureCell:cell forPost:post];
    
    // If the post is a link pointing to a HN page with a relative URL (like 'item?id=8175089'), open the post in the app
    if ([post.UrlString hasPrefix:@"item?"] || [post.UrlString hasPrefix:@"https://news.ycombinator.com/item?"]) {
        HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self commentsButtonPressed:cell.commentsButton];
        
        return;
    }
    
    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        HFModalWebViewController *webViewController = [[HFModalWebViewController alloc] initWithURL:[NSURL URLWithString:post.UrlString]];
        self.scaleTransition = [DMScaleTransition new];
        webViewController.transitioningDelegate = self.scaleTransition;
        [self presentViewController:webViewController animated:YES completion:nil];
    } else {
        HFWebViewController *webViewController = [[HFWebViewController alloc] init];
        webViewController.URL = [NSURL URLWithString:post.UrlString];
        
        [self showViewController:webViewController sender:self];
    }
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
