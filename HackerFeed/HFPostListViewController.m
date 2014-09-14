//
//  HFPostListViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostListViewController.h"

#import "DMScaleTransition.h"
#import "HFModalWebViewController.h"
#import "HFNavigationBar.h"
#import "HFNewPostViewController.h"
#import "HFPostTableViewCell.h"
#import "HFPostViewController.h"
#import "PBWebViewController.h"
#import "SVProgressHUD.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface HFPostListViewController () <UITableViewDataSource, UITableViewDelegate>

@property DMScaleTransition *scaleTransition;

- (void)refresh;

@end

static NSString * const kPostTableViewCellIdentifier = @"PostTableViewCell";

static NSString * const kPostSegueIdentifier = @"PostSegue";
static NSString * const kPostCommentsSegueIdentifier = @"PostCommentsSegue";

@implementation HFPostListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 72.0f;
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                               target:self
                                                                                               action:@selector(newPostButtonPressed)];
    }
    
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    __weak typeof(self) welf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [welf refresh];
    }];
    
    self.tableView.pullToRefreshView.titleLabel.font = [UIFont applicationFontOfSize:15.0f];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [welf loadMorePosts];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    HNPost *post = self.dataSource.posts[selectedIndexPath.row];
    
    // Bring the user to the in-app comments page for Ask HN posts, instead of opening the comments page in a web view
    if ([identifier isEqualToString:kPostSegueIdentifier] && post.Type == PostTypeAskHN) {
        HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
        [self performSegueWithIdentifier:kPostCommentsSegueIdentifier sender:cell.commentsButton];
        return NO;
    } else if ([identifier isEqualToString:kPostSegueIdentifier] && post.Type == PostTypeJobs && !post.UrlString) {
        HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
        [self performSegueWithIdentifier:kPostCommentsSegueIdentifier sender:cell.commentsButton];
        return NO;
    }
    
    return YES;
}

- (void)refresh {
    [self.dataSource refreshWithCompletion:^(BOOL completed) {
        if (completed) {
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Could not load posts", nil)];
        }

        [self.tableView.pullToRefreshView stopAnimating];
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

- (void)commentsButtonPressed:(HFCommentsButton *)sender {
    HFPostViewController *postViewController = [[HFPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *postNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                     toolbarClass:nil];
    postNavigationController.viewControllers = @[postViewController];
    HFCommentsButton *commentsButton = (HFCommentsButton *)sender;
    postViewController.post = self.dataSource.posts[commentsButton.tag];
    
    [self showDetailViewController:postNavigationController sender:self];
}

- (void)newPostButtonPressed {
    HFNewPostViewController *newPostViewController = [[HFNewPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                 toolbarClass:nil];
    navigationController.viewControllers = @[newPostViewController];
    
    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    } else {
        self.scaleTransition = [DMScaleTransition new];
        navigationController.transitioningDelegate = self.scaleTransition;
    }

    [self.splitViewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Getters/Setters

- (void)setDataSource:(id<HFPostDataSource>)dataSource {
    _dataSource = dataSource;
    [self refresh];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFPostTableViewCell *postTableViewCell = [tableView dequeueReusableCellWithIdentifier:kPostTableViewCellIdentifier forIndexPath:indexPath];
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    postTableViewCell.titleLabel.text = post.Title;
    postTableViewCell.domainLabel.text = post.UrlDomain;
    
    if (post.Type == PostTypeJobs) {
        postTableViewCell.infoLabel.text = nil;
    } else {
        postTableViewCell.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d points · %@", nil), post.Points, [post.Username lowercaseString]];
    }
    
    [postTableViewCell.commentsButton setTitle:[NSString stringWithFormat:@"%d", post.CommentCount] forState:UIControlStateNormal];
    postTableViewCell.commentsButton.tag = indexPath.row;
    [postTableViewCell.commentsButton addTarget:self action:@selector(commentsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return postTableViewCell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static HFPostTableViewCell *postMetricsCell;
//
//    if (!postMetricsCell) {
//        postMetricsCell = [[HFPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    }
//    
//    postMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
//    
//    HNPost *post = self.dataSource.posts[indexPath.row];
//    
//    postMetricsCell.titleLabel.text = post.Title;
//    postMetricsCell.domainLabel.text = post.UrlDomain;
//
//    if (post.Type == PostTypeJobs) {
//        postMetricsCell.infoLabel.text = nil;
//    } else {
//        postMetricsCell.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d points · %@", nil), post.Points, [post.Username lowercaseString]];
//    }
//    
//    [postMetricsCell setNeedsLayout];
//    [postMetricsCell layoutIfNeeded];
//    
//    CGSize size = [postMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
//    CGFloat cellHeight = size.height + 1;
//    
//    return cellHeight;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    // If the post is a jobs link pointing to a HN page with a relative URL (like 'item?id=8175089'), open the post in the app
    if (post.Type == PostTypeJobs && [post.UrlString hasPrefix:@"item?"]) {
        HFPostTableViewCell *cell = (HFPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self commentsButtonPressed:cell.commentsButton];
        
        return;
    }
    
    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        HFModalWebViewController *webViewController = [[HFModalWebViewController alloc] initWithURL:[NSURL URLWithString:post.UrlString]];
        self.scaleTransition = [DMScaleTransition new];
        webViewController.transitioningDelegate = self.scaleTransition;
        [self.splitViewController presentViewController:webViewController animated:YES completion:nil];
    } else {
        PBWebViewController *webViewController = [[PBWebViewController alloc] init];
        webViewController.URL = [NSURL URLWithString:post.UrlString];
        
        [self showViewController:webViewController sender:self];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
