//
//  HFPostListViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostListViewController.h"

#import "DMScaleTransition.h"
#import "DMSlideTransition.h"
#import "HFNewPostViewController.h"
#import "HFPostTableViewCell.h"
#import "HFPostViewController.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[HFPostTableViewCell class] forCellReuseIdentifier:kPostTableViewCellIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self
                                                                                           action:@selector(newPostButtonPressed)];
    [self refresh];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kPostSegueIdentifier]) {
        HNPost *post = self.dataSource.posts[[self.tableView indexPathForSelectedRow].row];
        SVWebViewController *webViewController = (SVWebViewController *)segue.destinationViewController;
        [webViewController loadURL:[NSURL URLWithString:post.UrlString]];
    } else if ([segue.identifier isEqualToString:kPostCommentsSegueIdentifier]) {
        HFPostViewController *postViewController = (HFPostViewController *)segue.destinationViewController;
        HFCommentsButton *commentsButton = (HFCommentsButton *)sender;
        postViewController.post = self.dataSource.posts[commentsButton.tag];
    }
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

- (void)commentsButtonPressed:(id)sender {
    HFPostViewController *postViewController = [[HFPostViewController alloc] initWithNibName:nil bundle:nil];
    HFCommentsButton *commentsButton = (HFCommentsButton *)sender;
    postViewController.post = self.dataSource.posts[commentsButton.tag];
    
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)newPostButtonPressed {
    HFNewPostViewController *newPostViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                                                bundle:nil] instantiateViewControllerWithIdentifier:@"NewPostViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newPostViewController];
    self.scaleTransition = [DMScaleTransition new];
    navigationController.transitioningDelegate = self.scaleTransition;
    
    [self presentViewController:navigationController animated:YES completion:nil];
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
        postTableViewCell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", post.Points, [post.Username lowercaseString]];
    }
    
    [postTableViewCell.commentsButton setTitle:[NSString stringWithFormat:@"%d", post.CommentCount] forState:UIControlStateNormal];
    postTableViewCell.commentsButton.tag = indexPath.row;
    [postTableViewCell.commentsButton addTarget:self action:@selector(commentsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return postTableViewCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static HFPostTableViewCell *postMetricsCell;

    if (!postMetricsCell) {
        postMetricsCell = [[HFPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    postMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
    
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    postMetricsCell.titleLabel.text = post.Title;
    postMetricsCell.domainLabel.text = post.UrlDomain;
    postMetricsCell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", post.Points, post.Username];
    
    [postMetricsCell setNeedsLayout];
    [postMetricsCell layoutIfNeeded];
    
    CGSize size = [postMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    CGFloat cellHeight = size.height + 1;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    if (post.Type == PostTypeJobs) {
        return;
    }
    
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:post.UrlString];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
