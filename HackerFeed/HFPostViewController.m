//
//  HFPostViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostViewController.h"

#import "DMScaleTransition.h"
#import "HFCommentTableViewCell.h"
#import "HFCommentToolbar.h"
#import "HFPostInfoTableViewCell.h"
#import "HFProfileViewController.h"
#import "HFTableViewCell.h"
#import "HFWebViewController.h"
#import "SVProgressHUD.h"

@interface HFPostViewController () <HFCommentTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property UILabel *selectPostLabel;
@property UITableView *tableView;
@property UIBarButtonItem *upvoteButton;
@property HFCommentToolbar *commentToolbar;
@property NSLayoutConstraint *commentToolbarHeightConstraint;

@property NSIndexPath *expandedIndexPath;
@property NSArray *comments;
@property HNComment *commentToReply;

@property DMScaleTransition *scaleTransition;

@property NSMutableDictionary *commentCellHeightCache;

- (void)addKeyboardNotificationObservers;
- (void)upvoteButtonPressed:(id)sender;

@end

static NSString * const kCommentTableViewCellIdentifier = @"CommentTableViewCell";
static NSString * const kUsernameTableViewCellIdentifier = @"UsernameTableViewCell";
static NSString * const kPostInfoTableViewCellIdentifier = @"PostInfoTableViewCell";

static NSString * const kCommentsWebSegueIdentifier = @"CommentsWebSegue";
static NSString * const kCommentsProfileSegueIdentifier = @"CommentsProfileSegue";

@implementation HFPostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
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
        self.selectPostLabel.font = [UIFont applicationFontOfSize:20.0f];
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
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView][_commentToolbar]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView, _commentToolbar)]];
        
        self.commentToolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.commentToolbar
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0f
                                                                            constant:44.0f];
        
        id <UILayoutSupport> topGuide = self.topLayoutGuide;
        
        // Ensure the comment toolbar doesn't expand under the navigation bar when the user is typing a long comment
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-(>=0)-[_commentToolbar]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(topGuide, _commentToolbar)]];
        
        [self addKeyboardNotificationObservers];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upvoteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UpvoteIcon"] style:UIBarButtonItemStyleBordered target:self action:@selector(upvoteButtonPressed:)];
    self.navigationItem.rightBarButtonItem = self.upvoteButton;
    
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
}

- (void)setPost:(HNPost *)post {
    _post = post;
    
    if (post) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.selectPostLabel.hidden = YES;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectPostLabel.hidden = NO;
    }
    
    // Hide the upvote button if we're looking at a job post (that can't be voted on)
    if (post.Type == PostTypeJobs) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.upvoteButton.enabled = ![[HNManager sharedManager] hasVotedOnObject:post];
    }
    
    // Clear the cell height cache
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
    
    self.expandedIndexPath = nil;
    
    // Scroll to the top of the table view
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    [[HNManager sharedManager] loadCommentsFromPost:post completion:^(NSArray *comments) {
        self.comments = comments;
        [self.tableView reloadData];
    }];
}

- (void)addKeyboardNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      CGRect keyboardFrame = [self.view convertRect:[(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                                                                           fromView:nil];
                                                      CGRect viewFrame = self.view.frame;
                                                      viewFrame.size.height -= keyboardFrame.size.height;
                                                      
                                                      UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
                                                      NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                                                      
                                                      [UIView animateWithDuration:animationDuration
                                                                            delay:0
                                                                          options:UIViewAnimationOptionBeginFromCurrentState | curve
                                                                       animations:^{
                                                                           self.view.frame = viewFrame;
                                                                       }
                                                                       completion:nil];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      // [self performIfVisible:^{
                                                      CGRect keyboardFrame = [self.view convertRect:[(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                                                                           fromView:nil];
                                                      CGRect viewFrame = self.view.frame;
                                                      viewFrame.size.height += keyboardFrame.size.height;
                                                      
                                                      UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
                                                      NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                                                      
                                                      [UIView animateWithDuration:animationDuration
                                                                            delay:0
                                                                          options:UIViewAnimationOptionBeginFromCurrentState | curve
                                                                       animations:^{
                                                                           self.view.frame = viewFrame;
                                                                       }
                                                                       completion:nil];
                                                      // }];
                                                  }];
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
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting comment", nil)];
        }
    }];
}

#pragma mark - HFCommentTableViewCellDelegate

- (void)commentTableViewCellTapped:(HFCommentTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row >= 2) {
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
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.post ? 2 + [self.comments count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HFPostInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostInfoTableViewCellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = self.post.Title;
        cell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", self.post.Points, self.post.TimeCreatedString];
        return cell;
    } else if (indexPath.row == 1) {
        HFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUsernameTableViewCellIdentifier forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont smallCapsApplicationFontWithSize:cell.textLabel.font.pointSize];
        cell.textLabel.text = NSLocalizedString(@"submitted by", nil);
        cell.detailTextLabel.font = [UIFont applicationFontOfSize:16.0f];
        cell.detailTextLabel.text = self.post.Username;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        HFCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCommentTableViewCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        
        HNComment *comment = self.comments[indexPath.row - 2];
        cell.textView.text = comment.Text;
        // Set the delegate so we can open detected links
        cell.textView.delegate = self;
        cell.textView.textContainerInset = UIEdgeInsetsZero;
        cell.usernameLabel.text = comment.Username;
        
        cell.usernameLabelLeadingConstraint.constant = 15.0f + (comment.Level * 15.0f);
        cell.textViewLeadingConstraint.constant = 10.0f + (comment.Level * 15.0f);
        cell.toolbarHeightConstraint.constant = 0.0f;
        
        [cell.commentActionsView.upvoteButton addTarget:self action:@selector(upvoteCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentActionsView.upvoteButton.tag = indexPath.row - 2;
        cell.commentActionsView.upvoteButton.enabled = ![[HNManager sharedManager] hasVotedOnObject:comment];
        
        [cell.commentActionsView.replyButton addTarget:self action:@selector(commentReplyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentActionsView.replyButton.tag = indexPath.row - 2;
        
        [cell.commentActionsView.userButton addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentActionsView.userButton.tag = indexPath.row - 2;
        
        if ([self.expandedIndexPath isEqual:indexPath]) {
            [cell setExpanded:YES animated:NO];
        } else {
            [cell setExpanded:NO animated:NO];
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f + (comment.Level * 15.0f), 0.0f, 0.0f);
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    } else {
        NSNumber *cachedCellHeight = self.commentCellHeightCache[@(indexPath.row)];
        if (cachedCellHeight && ![indexPath isEqual:self.expandedIndexPath]) {
            return [cachedCellHeight floatValue];
        }
        
        static HFCommentTableViewCell *commentMetricsCell;

        if (!commentMetricsCell) {
            commentMetricsCell = [tableView dequeueReusableCellWithIdentifier:kCommentTableViewCellIdentifier];
        }
        
        CGRect frame = commentMetricsCell.frame;
        frame.size.width = self.tableView.bounds.size.width;
        commentMetricsCell.frame = frame;
        
        HNComment *comment = self.comments[indexPath.row - 2];
        commentMetricsCell.textView.text = comment.Text;
        commentMetricsCell.usernameLabel.text = comment.Username;
        commentMetricsCell.usernameLabelLeadingConstraint.constant = 15.0f + (comment.Level * 15.0f);
        commentMetricsCell.textViewLeadingConstraint.constant = 10.0f + (comment.Level * 15.0f);
        commentMetricsCell.toolbarHeightConstraint.constant = 0.0f;
        
        if ([self.expandedIndexPath isEqual:indexPath]) {
            commentMetricsCell.expanded = YES;
        } else {
            commentMetricsCell.expanded = NO;
        }
        
        commentMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
        
        [commentMetricsCell setNeedsLayout];
        [commentMetricsCell layoutIfNeeded];
        
        CGSize size = [commentMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        CGFloat cellHeight = size.height - 12;
        
        // If the cell isn't expanded, cache the row height
        if (![indexPath isEqual:self.expandedIndexPath]) {
            self.commentCellHeightCache[@(indexPath.row)] = @(cellHeight);
        }
        
        return cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HFWebViewController *webViewController = [[HFWebViewController alloc] initWithAddress:self.post.UrlString];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *webViewNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
            self.scaleTransition = [DMScaleTransition new];
            webViewNavigationController.transitioningDelegate = self.scaleTransition;
            [self.splitViewController presentViewController:webViewNavigationController animated:YES completion:nil];
        } else {
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    } else if (indexPath.row == 1) {
        HFProfileViewController *profileViewController = [[HFProfileViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:profileViewController animated:YES];
        [[HNManager sharedManager] loadUserWithUsername:self.post.Username completion:^(HNUser *user) {
            profileViewController.user = user;
        }];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        HFWebViewController *webViewController = [[HFWebViewController alloc] initWithURL:URL];
        UINavigationController *webViewNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        self.scaleTransition = [DMScaleTransition new];
        webViewNavigationController.transitioningDelegate = self.scaleTransition;
        [self.splitViewController presentViewController:webViewNavigationController animated:YES completion:nil];
    } else {
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    // If the user hits the return key, dismiss the keyboard
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
