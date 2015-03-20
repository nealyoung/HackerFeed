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
#import "HFPullToRefreshContentView.h"
#import "HFToolbar.h"
#import "HFWebViewController.h"
#import "SSPullToRefresh.h"
#import "SVProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface HFPostListViewController () <SSPullToRefreshViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property DMScaleTransition *scaleTransition;
@property SSPullToRefreshView *pullToRefreshView;

- (void)applyTheme;
- (void)refresh;

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

- (void)commentsButtonPressed:(HFCommentsButton *)sender {
    HFPostViewController *postViewController = [[HFPostViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *postNavigationController = [[UINavigationController alloc] initWithNavigationBarClass:[HFNavigationBar class]
                                                                                                     toolbarClass:[HFToolbar class]];
    postNavigationController.viewControllers = @[postViewController];
    HFCommentsButton *commentsButton = (HFCommentsButton *)sender;
    postViewController.post = self.dataSource.posts[commentsButton.tag];
    
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
        navigationController.modalPresentationStyle = UIModalPresentationPopover;
        self.scaleTransition = [DMScaleTransition new];
        navigationController.transitioningDelegate = self.scaleTransition;
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
    
    postTableViewCell.titleLabel.text = post.Title;
    postTableViewCell.domainLabel.text = post.UrlDomain;
    
    if (post.Type == PostTypeJobs) {
        postTableViewCell.infoLabel.text = nil;
    } else {
        postTableViewCell.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d points · %@", nil), post.Points, [post.Username lowercaseString]];
    }
    
    if (post.CommentCount >= 1000) {
        [postTableViewCell.commentsButton setTitle:@"1k+" forState:UIControlStateNormal];
    } else {
        [postTableViewCell.commentsButton setTitle:[NSString stringWithFormat:@"%d", post.CommentCount] forState:UIControlStateNormal];
    }
    
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
    
    if (post.Type == PostTypeJobs) {
        postMetricsCell.infoLabel.text = nil;
    } else {
        postMetricsCell.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d points · %@", nil), post.Points, [post.Username lowercaseString]];
    }
    
    [postMetricsCell setNeedsLayout];
    [postMetricsCell layoutIfNeeded];
    
    CGSize size = [postMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    CGFloat cellHeight = size.height + 1;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HNPost *post = self.dataSource.posts[indexPath.row];
    
    // If the post is a link pointing to a HN page with a relative URL (like 'item?id=8175089'), open the post in the app
    if ([post.UrlString hasPrefix:@"item?"]) {
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
        HFWebViewController *webViewController = [[HFWebViewController alloc] init];
        webViewController.URL = [NSURL URLWithString:post.UrlString];
        
        [self showViewController:webViewController sender:self];
    }
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
