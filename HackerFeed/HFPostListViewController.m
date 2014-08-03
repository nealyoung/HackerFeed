//
//  HFPostListViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 6/17/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostListViewController.h"

#import "HFPostTableViewCell.h"
#import "HFPostViewController.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface HFPostListViewController () <UITableViewDataSource, UITableViewDelegate>

- (void)refresh;

@end

static NSString * const kPostTableViewCellIdentifier = @"PostTableViewCell";

static NSString * const kPostSegueIdentifier = @"PostSegue";
static NSString * const kPostCommentsSegueIdentifier = @"PostCommentsSegue";

@implementation HFPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    return postTableViewCell;
}

#pragma mark - UITableViewDelegate

static HFPostTableViewCell *postMetricsCell;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!postMetricsCell) {
        postMetricsCell = [tableView dequeueReusableCellWithIdentifier:kPostTableViewCellIdentifier];
    }
    
    CGRect frame = postMetricsCell.frame;
    frame.size.width = self.tableView.bounds.size.width;
    postMetricsCell.frame = frame;
    
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    postMetricsCell.titleLabel.text = post.Title;
    postMetricsCell.domainLabel.text = post.UrlDomain;
    postMetricsCell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", post.Points, post.Username];
    
    [postMetricsCell setNeedsLayout];
    [postMetricsCell layoutIfNeeded];
    
    CGSize size = [postMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat cellHeight = size.height + 1;
    
    return cellHeight;
}

@end
