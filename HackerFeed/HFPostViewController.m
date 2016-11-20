//
//  HFPostViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostViewController.h"

#import <SafariServices/SafariServices.h>
#import "DMScaleTransition.h"
#import "HFCommentTableViewCell.h"
#import "HFCommentToolbar.h"
#import "HFNavigationBar.h"
#import "HFPostInfoTableViewCell.h"
#import "HFProfileViewController.h"
#import "HFPullToRefreshContentView.h"
#import "HFTableView.h"
#import "HFTableViewCell.h"
#import "SSPullToRefresh.h"
#import "SVProgressHUD.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface HFPostViewController () <HFCommentTableViewCellDelegate, SSPullToRefreshViewDelegate, TTTAttributedLabelDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

// Store the default frame of the view so we can restore it after the keyboard is hidden
@property CGRect originalViewFrame;

@property SSPullToRefreshView *pullToRefreshView;

@property UILabel *selectPostLabel;
@property UITableView *tableView;
@property UIBarButtonItem *upvoteButton;
@property HFCommentToolbar *commentToolbar;

@property NSIndexPath *expandedIndexPath;
@property NSArray *comments;
@property HNComment *commentToReply;

@property DMScaleTransition *scaleTransition;

@property NSMutableDictionary *commentCellHeightCache;

- (void)addKeyboardNotificationObservers;
- (void)upvoteButtonPressed:(id)sender;
- (void)refresh;

- (void)upvoteCommentButtonPressed:(UIButton *)sender;
- (void)commentReplyButtonPressed:(UIButton *)sender;
- (void)userButtonPressed:(UIButton *)sender;
- (void)cancelReplyButtonPressed:(UIButton *)sender;
- (void)submitCommentButtonPressed:(UIButton *)sender;

- (void)upvoteCommentGestureActivatedForCell:(UITableViewCell *)cell;

- (void)clearCommentCellHeightCache;

@end

static NSInteger const kPostInformationSection = 0;
static NSInteger const kCommentsSection = 1;

static NSString * const kCommentTableViewCellIdentifier = @"CommentTableViewCell";
static NSString * const kUsernameTableViewCellIdentifier = @"UsernameTableViewCell";
static NSString * const kPostInfoTableViewCellIdentifier = @"PostInfoTableViewCell";

@implementation HFPostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.tableView = [[HFTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.estimatedRowHeight = 64.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Hide the cell separators until a post is set
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.tableView registerClass:[HFPostInfoTableViewCell class] forCellReuseIdentifier:kPostInfoTableViewCellIdentifier];
        [self.tableView registerClass:[HFTableViewCell class] forCellReuseIdentifier:kUsernameTableViewCellIdentifier];
        [self.tableView registerClass:[HFCommentTableViewCell class] forCellReuseIdentifier:kCommentTableViewCellIdentifier];
        [self.view addSubview:self.tableView];
        
        self.commentToolbar = [[HFCommentToolbar alloc] initWithFrame:CGRectZero];
        [self.commentToolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.commentToolbar.textView.placeholder = NSLocalizedString(@"Comment", nil);
        self.commentToolbar.textView.delegate = self;
        [self.commentToolbar.cancelReplyButton addTarget:self
                                                  action:@selector(cancelReplyButtonPressed:)
                                        forControlEvents:UIControlEventTouchUpInside];
        [self.commentToolbar.submitButton addTarget:self
                                             action:@selector(submitCommentButtonPressed:)
                                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.commentToolbar];
        
        self.selectPostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.selectPostLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.selectPostLabel.font = [UIFont systemFontOfSize:20.0f];
        self.selectPostLabel.textColor = [UIColor darkGrayColor];
        self.selectPostLabel.text = NSLocalizedString(@"Select a post", nil);
        [self.view addSubview:self.selectPostLabel];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectPostLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selectPostLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentToolbar]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_commentToolbar)]];
        
        id <UILayoutSupport> topGuide = self.topLayoutGuide;

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide][_tableView][_commentToolbar]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(topGuide, _tableView, _commentToolbar)]];
        
        // Ensure the comment toolbar doesn't expand under the navigation bar when the user is typing a long comment
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-(>=0)-[_commentToolbar]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(topGuide, _commentToolbar)]];
        
//        [self addKeyboardNotificationObservers];
        
        self.post = nil;
        
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCommentCellHeightCache) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upvoteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BarButtonUpvoteIcon"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(upvoteButtonPressed:)];
    
    self.upvoteButton.accessibilityLabel = @"Upvote";
    self.upvoteButton.accessibilityHint = NSLocalizedString(@"Upvotes the story", nil);
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MoreIcon"]
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(actionButtonPressed:)];
    self.navigationItem.rightBarButtonItems = @[self.upvoteButton, shareButton];
    
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.pullToRefreshView) {
        self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
        self.pullToRefreshView.contentView = [[HFPullToRefreshContentView alloc] initWithFrame:CGRectZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [self clearCommentCellHeightCache];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    } completion:nil];
}

- (void)applyTheme {
    self.selectPostLabel.textColor = [HFInterfaceTheme activeTheme].secondaryTextColor;
    self.view.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.03f];
}

- (void)refresh {
    [[HNManager sharedManager] loadCommentsFromPost:self.post completion:^(NSArray *comments) {
        self.comments = comments;
        [self.tableView reloadData];
        
        [self.pullToRefreshView finishLoading];
    }];
}

- (void)setPost:(HNPost *)post {
    _post = post;
    
    if (post) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.selectPostLabel.hidden = YES;
        self.commentToolbar.hidden = NO;
        
        [[HNManager sharedManager] loadCommentsFromPost:post completion:^(NSArray *comments) {
            self.comments = comments;
            [self.tableView reloadData];
        }];
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectPostLabel.hidden = NO;
        self.commentToolbar.hidden = YES;
    }
    
    // Disable the upvote button if the post is nil, if the user has already voted, or if we're looking at a job post (that can't be voted on)
    self.upvoteButton.enabled = !(!post || [[HNManager sharedManager] hasVotedOnObject:post] || post.Type == PostTypeJobs);
    
    // Clear the cell height cache
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
    
    self.expandedIndexPath = nil;
    
    self.comments = @[];
    self.commentToReply = nil;
    [self.commentToolbar.textView resignFirstResponder];
    
    [self.tableView reloadData];

    // Scroll to the top of the table view
    [self.tableView scrollRectToVisible:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) animated:YES];
}

- (void)addKeyboardNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      // Only perform if visible
                                                      if (!self.isViewLoaded || !self.view.window) {
                                                          return;
                                                      }
                                                      
                                                      CGRect keyboardFrame = [self.view convertRect:[(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                                                                           fromView:nil];
                                                      CGRect viewFrame = self.view.frame;
                                                      viewFrame.size.height = CGRectGetMinY(keyboardFrame);
                                                      
                                                      UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
                                                      NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                                                      
                                                      // There is no animationDuration key when the user shows/hides the suggestions bar under iOS 8
                                                      if (animationDuration == 0.0f) {
                                                          animationDuration = 0.25f;
                                                      }
                                                      
                                                      [UIView animateWithDuration:animationDuration
                                                                            delay:0
                                                                          options:UIViewAnimationOptionBeginFromCurrentState | curve
                                                                       animations:^{
                                                                           self.view.frame = viewFrame;
                                                                       }
                                                                       completion:nil];
                                                  }];
}

- (void)actionButtonPressed:(id)sender {
    NSArray *activityItems = @[[NSURL URLWithString:self.post.UrlString]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:TRUE completion:nil];
}

- (void)upvoteButtonPressed:(id)sender {
    if (![HNManager sharedManager].SessionUser) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You must be signed in to vote", nil)];
        return;
    }
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [ai startAnimating];
    [[HNManager sharedManager] voteOnPostOrComment:self.post direction:VoteDirectionUp completion:^(BOOL success) {
        self.navigationItem.rightBarButtonItem = self.upvoteButton;

        if (success) {
            self.upvoteButton.enabled = NO;
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting vote", nil)];
        }
    }];
}

- (void)upvoteCommentButtonPressed:(UIButton *)sender {
    if (![HNManager sharedManager].SessionUser) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You must be signed in to vote", nil)];
        return;
    }
    
    sender.enabled = NO;

    HNComment *comment = self.comments[sender.tag];
    [[HNManager sharedManager] voteOnPostOrComment:comment direction:VoteDirectionUp completion:^(BOOL success) {
        if (success) {

        } else {
            sender.enabled = YES;
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting vote", nil)];
        }
    }];
}

- (void)commentReplyButtonPressed:(UIButton *)sender {
    self.commentToReply = self.comments[sender.tag];
    self.commentToolbar.replyUsername = self.commentToReply.Username;
    [self.commentToolbar.textView becomeFirstResponder];
}

- (void)userButtonPressed:(UIButton *)sender {
    HNComment *comment = self.comments[sender.tag];
    
    HFProfileViewController *profileViewController = [[HFProfileViewController alloc] initWithNibName:nil bundle:nil];
    [[HNManager sharedManager] loadUserWithUsername:comment.Username completion:^(HNUser *user) {
        profileViewController.user = user;
    }];
    
    [self.navigationController pushViewController:profileViewController animated:YES];
}

- (void)cancelReplyButtonPressed:(UIButton *)sender {
    self.commentToReply = nil;
    self.commentToolbar.replyUsername = nil;
}

- (void)submitCommentButtonPressed:(UIButton *)sender {
    if (![HNManager sharedManager].SessionUser) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You must be signed in to comment", nil)];
        return;
    }
    
    id itemToReply = self.commentToReply ? self.commentToReply : self.post;
    [[HNManager sharedManager] replyToPostOrComment:itemToReply withText:self.commentToolbar.textView.text completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Comment submitted", nil)];
            self.commentToolbar.textView.text = @"";
            
            // Reload the comments so the new comment is displayed
            [[HNManager sharedManager] loadCommentsFromPost:self.post completion:^(NSArray *comments) {
                self.comments = comments;
                [self.tableView reloadData];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting comment", nil)];
        }
    }];
}

- (void)clearCommentCellHeightCache {
    [self.commentCellHeightCache removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

#pragma mark - Swipe Gesture Handlers

- (void)upvoteCommentGestureActivatedForCell:(UITableViewCell *)cell {
    if (![HNManager sharedManager].SessionUser) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You must be signed in to vote", nil)];
        return;
    }
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    
    HNComment *comment = self.comments[cellIndexPath.row];
    [[HNManager sharedManager] voteOnPostOrComment:comment direction:VoteDirectionUp completion:^(BOOL success) {
        if (success) {
            
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting vote", nil)];
        }
    }];
}

- (void)replyToCommentGestureActivatedForCell:(UITableViewCell *)cell {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

    self.commentToReply = self.comments[cellIndexPath.row];
    self.commentToolbar.replyUsername = self.commentToReply.Username;
    [self.commentToolbar.textView becomeFirstResponder];
}

- (void)viewUserGestureActivatedForCell:(UITableViewCell *)cell {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

    HNComment *comment = self.comments[cellIndexPath.row];
    
    HFProfileViewController *profileViewController = [[HFProfileViewController alloc] initWithNibName:nil bundle:nil];
    [[HNManager sharedManager] loadUserWithUsername:comment.Username completion:^(HNUser *user) {
        profileViewController.user = user;
    }];
    
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - HFCommentTableViewCellDelegate

- (void)commentTableViewCellTapped:(HFCommentTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HFCommentTableViewCell *selectedCell = (HFCommentTableViewCell *)[self.tableView cellForRowAtIndexPath:self.expandedIndexPath];
    
    [self.tableView beginUpdates];
    
    // If the previously selected cell is visible, we need to hide the action bar
    if (selectedCell) {
        selectedCell.expanded = NO;
    }
    
    // If the tapped cell is already expanded, don't do anything else
    if ([indexPath isEqual:self.expandedIndexPath]) {
        self.expandedIndexPath = nil;
    } else {
        HFCommentTableViewCell *cell = (HFCommentTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.expanded = YES;
        self.expandedIndexPath = indexPath;
    }
    
    [self.tableView endUpdates];
}

#pragma mark - SSPullToRefreshDelegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:safariViewController animated:YES completion:nil];
    
//    if (self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
//        HFModalWebViewController *webViewController = [[HFModalWebViewController alloc] initWithURL:url];
//        self.scaleTransition = [DMScaleTransition new];
//        webViewController.transitioningDelegate = self.scaleTransition;
//        [self.splitViewController presentViewController:webViewController animated:YES completion:nil];
//    } else {
//        HFWebViewController *webViewController = [[HFWebViewController alloc] init];
//        webViewController.URL = url;
//        
//        [self showViewController:webViewController sender:self];
//    }
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.post ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kPostInformationSection) {
        if (self.post.Type == PostTypeJobs) {
            return 1;
        } else {
            return 2;
        }
    } else if (section == kCommentsSection) {
        return [self.comments count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kPostInformationSection) {
        if (indexPath.row == 0) {
            HFPostInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostInfoTableViewCellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = self.post.Title;
            
            // Don't display score/time created info for jobs posts
            cell.infoLabel.text = self.post.Type == PostTypeJobs ? nil : [NSString stringWithFormat:@"%d points · %@", self.post.Points, self.post.TimeCreatedString];
            
            return cell;
        } else if (indexPath.row == 1 && self.post.Type != PostTypeJobs) {
            HFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUsernameTableViewCellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(@"Submitted by", nil);
            cell.detailTextLabel.text = self.post.Username;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    } else if (indexPath.section == kCommentsSection) {
        HFCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCommentTableViewCellIdentifier forIndexPath:indexPath];

        cell.gestureDelegate = self;
        cell.tag = indexPath.row;
        
        HNComment *comment = self.comments[indexPath.row];
        
        cell.commentLabel.text = comment.Text;
        
        // Set the label's delegate so we can open detected links
        cell.commentLabel.delegate = self;
        
        cell.usernameLabel.text = [NSString stringWithFormat:@"%@ · %@", comment.Username, comment.TimeCreatedString];
        
        cell.usernameLabelLeadingConstraint.constant = tableView.separatorInset.left + (comment.Level * 16.0f);
        
        // UITextView has a 5pt content inset
        cell.commentLabelLeadingConstraint.constant = tableView.separatorInset.left + (comment.Level * 16.0f);
        cell.toolbarHeightConstraint.constant = 0.0f;
        
        [cell.commentActionsView.upvoteButton addTarget:self action:@selector(upvoteCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentActionsView.upvoteButton.tag = indexPath.row;
        cell.commentActionsView.upvoteButton.enabled = ![[HNManager sharedManager] hasVotedOnObject:comment];
        
        [cell.commentActionsView.replyButton addTarget:self action:@selector(commentReplyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentActionsView.replyButton.tag = indexPath.row;
        
        [cell.commentActionsView.userButton addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentActionsView.userButton.tag = indexPath.row;
        
        if ([self.expandedIndexPath isEqual:indexPath]) {
            [cell setExpanded:YES animated:NO];
        } else {
            [cell setExpanded:NO animated:NO];
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0.0f, tableView.separatorInset.left + (comment.Level * tableView.separatorInset.left), 0.0f, 0.0f);

        UIImageView *upvoteIconImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BarButtonUpvoteIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        upvoteIconImageView.tintColor = [UIColor whiteColor];
        
        UIImageView *replyIconImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ReplyIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        replyIconImageView.tintColor = [UIColor whiteColor];
        
        UIImageView *userIconImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"UserIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        userIconImageView.tintColor = [UIColor whiteColor];

//        [cell setSwipeGestureWithView:upvoteIconImageView
//                                color:[HFInterfaceTheme activeTheme].accentColor
//                                 mode:MCSwipeTableViewCellModeSwitch
//                                state:MCSwipeTableViewCellState1
//                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
//                          [self upvoteCommentGestureActivatedForCell:cell];
//                      }];
//        
//        [cell setSwipeGestureWithView:replyIconImageView
//                                color:[[HFInterfaceTheme activeTheme].accentColor hf_colorLightenedByFactor:0.08f]
//                                 mode:MCSwipeTableViewCellModeSwitch
//                                state:MCSwipeTableViewCellState3
//                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
//                          [self replyToCommentGestureActivatedForCell:cell];
//                      }];
//        
//        [cell setSwipeGestureWithView:userIconImageView
//                                color:[[HFInterfaceTheme activeTheme].accentColor hf_colorLightenedByFactor:0.16f]
//                                 mode:MCSwipeTableViewCellModeSwitch
//                                state:MCSwipeTableViewCellState4
//                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
//                          [self viewUserGestureActivatedForCell:cell];
//                      }];
        

        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
    
    if (indexPath.section == kPostInformationSection) {
        if (indexPath.row == 0) {
            static HFPostInfoTableViewCell *postInfoMetricsCell;
            
            if (!postInfoMetricsCell) {
                postInfoMetricsCell = [[HFPostInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            }
            
            CGRect frame = postInfoMetricsCell.frame;
            frame.size.width = self.tableView.bounds.size.width;
            postInfoMetricsCell.frame = frame;
            
            postInfoMetricsCell.titleLabel.text = self.post.Title;
            postInfoMetricsCell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", self.post.Points, self.post.TimeCreatedString];
            
            [postInfoMetricsCell setNeedsLayout];
            [postInfoMetricsCell layoutIfNeeded];
            [postInfoMetricsCell layoutSubviews];
            
            CGSize size = [postInfoMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            
            return (size.height + 1);
        } else if (indexPath.row == 1) {
            return 44.0f;
        }
    } else if (indexPath.section == kCommentsSection) {
        NSNumber *cachedCellHeight = self.commentCellHeightCache[@(indexPath.row)];
        if (cachedCellHeight && ![indexPath isEqual:self.expandedIndexPath]) {
            return [cachedCellHeight floatValue];
        }
        
        static HFCommentTableViewCell *commentMetricsCell;
        
        if (!commentMetricsCell) {
            commentMetricsCell = [tableView dequeueReusableCellWithIdentifier:kCommentTableViewCellIdentifier];
            commentMetricsCell.layoutMargins = tableView.layoutMargins;
        }
        
        CGRect frame = commentMetricsCell.frame;
        frame.size.width = self.tableView.bounds.size.width;
        commentMetricsCell.frame = frame;
        
        HNComment *comment = self.comments[indexPath.row];
        commentMetricsCell.commentLabel.text = comment.Text;
        commentMetricsCell.usernameLabel.text = comment.Username;
        commentMetricsCell.usernameLabelLeadingConstraint.constant = tableView.separatorInset.left + (comment.Level * 16.0f);
        commentMetricsCell.commentLabelLeadingConstraint.constant = tableView.separatorInset.left + (comment.Level * 16.0f);

        NSLog(@"%@", NSStringFromUIEdgeInsets(tableView.separatorInset));
        NSLog(@"%@", NSStringFromUIEdgeInsets(commentMetricsCell.contentView.layoutMargins));
        commentMetricsCell.toolbarHeightConstraint.constant = 0.0f;
        
        if ([self.expandedIndexPath isEqual:indexPath]) {
            [commentMetricsCell setExpanded:YES animated:NO];
        } else {
            [commentMetricsCell setExpanded:NO animated:NO];
        }
        
        commentMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
        
        [commentMetricsCell setNeedsLayout];
        [commentMetricsCell layoutIfNeeded];
        
        CGSize size = [commentMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        CGFloat cellHeight = size.height;
        
        // If the cell isn't expanded, cache the row height
        if (![indexPath isEqual:self.expandedIndexPath]) {
            self.commentCellHeightCache[@(indexPath.row)] = @(cellHeight);
        }
        
        return cellHeight;
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kPostInformationSection) {
        if (indexPath.row == 0) {
            // If the post url is relative to news.yc (job posts), don't do anything
            if (!self.post.UrlDomain) {
                return;
            }
            
            NSURL *postURL = [NSURL URLWithString:self.post.UrlString];
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:postURL];
            [self presentViewController:safariViewController animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            HFProfileViewController *profileViewController = [[HFProfileViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:profileViewController animated:YES];
            [[HNManager sharedManager] loadUserWithUsername:self.post.Username completion:^(HNUser *user) {
                profileViewController.user = user;
            }];
        }
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    // If the user hits the return key, dismiss the keyboard
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
