//
//  HFPostViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 7/20/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFPostViewController.h"

#import "HFCommentTableViewCell.h"
#import "HFCommentToolbar.h"
#import "HFPostInfoTableViewCell.h"
#import "HFProfileViewController.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"

@interface HFPostViewController () <HFCommentTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property IBOutlet UITableView *tableView;
@property IBOutlet UIBarButtonItem *upvoteButton;
@property IBOutlet HFCommentToolbar *commentToolbar;

@property NSIndexPath *expandedIndexPath;
@property NSArray *comments;
@property HNComment *commentToReply;

@property NSMutableDictionary *commentCellHeightCache;

- (IBAction)upvoteButtonPressed:(id)sender;

@end

static NSString * const kCommentTableViewCellIdentifier = @"CommentTableViewCell";
static NSString * const kUsernameTableViewCellIdentifier = @"UsernameTableViewCell";
static NSString * const kPostInfoTableViewCellIdentifier = @"PostInfoTableViewCell";

static NSString * const kCommentsWebSegueIdentifier = @"CommentsWebSegue";
static NSString * const kCommentsProfileSegueIdentifier = @"CommentsProfileSegue";

@implementation HFPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
    
    // Hide the upvote button if we're looking at a job post (that can't be voted on)
    if (self.post.Type == PostTypeJobs) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.upvoteButton.enabled = ![[HNManager sharedManager] hasVotedOnObject:self.post];
    }
    
    self.commentToolbar.textView.placeholder = NSLocalizedString(@"Comment", nil);
    self.commentToolbar.textView.delegate = self;
    
    [self.commentToolbar.cancelReplyButton addTarget:self
                                              action:@selector(cancelReplyButtonPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
    [self.commentToolbar.submitButton addTarget:self
                                         action:@selector(submitCommentButtonPressed:)
                               forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)setPost:(HNPost *)post {
    _post = post;
    
    // Clear the cell height cache
    self.commentCellHeightCache = [NSMutableDictionary dictionary];
    
    [[HNManager sharedManager] loadCommentsFromPost:post completion:^(NSArray *comments) {
        self.comments = comments;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kCommentsWebSegueIdentifier]) {
        SVWebViewController *webViewController = (SVWebViewController *)segue.destinationViewController;
        [webViewController loadURL:[NSURL URLWithString:self.post.UrlString]];
    } else if ([segue.identifier isEqualToString:kCommentsProfileSegueIdentifier]) {
        HFProfileViewController *profileViewController = (HFProfileViewController *)segue.destinationViewController;
        [[HNManager sharedManager] loadUserWithUsername:self.post.Username completion:^(HNUser *user) {
            profileViewController.user = user;
        }];
    } else if ([segue.identifier isEqualToString:kCommentsProfileSegueIdentifier] ) {
        
    };
}

- (IBAction)upvoteButtonPressed:(id)sender {
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

- (IBAction)upvoteCommentButtonPressed:(UIButton *)sender {
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

- (IBAction)commentReplyButtonPressed:(UIButton *)sender {
    self.commentToReply = self.comments[sender.tag];
    self.commentToolbar.replyUsername = self.commentToReply.Username;
    [self.commentToolbar.textView becomeFirstResponder];
}

- (IBAction)userButtonPressed:(UIButton *)sender {
    HNComment *comment = self.comments[sender.tag];
    
    HFProfileViewController *profileViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
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

#pragma mark - ORNCommentTableViewCellDelegate

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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HFPostInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostInfoTableViewCellIdentifier
                                                                              forIndexPath:indexPath];
        cell.titleLabel.text = self.post.Title;
        cell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", self.post.Points, self.post.TimeCreatedString];
        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUsernameTableViewCellIdentifier forIndexPath:indexPath];
        cell.textLabel.font = [UIFont smallCapsApplicationFontWithSize:cell.textLabel.font.pointSize];
        cell.detailTextLabel.font = [UIFont applicationFontOfSize:16.0f];
        cell.detailTextLabel.text = self.post.Username;
        return cell;
    }

    HFCommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCommentTableViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    HNComment *comment = self.comments[indexPath.row - 2];
    cell.textView.text = comment.Text;
    cell.textView.textContainerInset = UIEdgeInsetsZero;
    cell.usernameLabel.text = comment.Username;
    cell.usernameLabelLeadingConstraint.constant = 15.0f + (comment.Level * 15.0f);
    cell.textViewLeadingConstraint.constant = 10.0f + (comment.Level * 15.0f);
    cell.toolbarHeightConstraint.constant = 0.0f;
    cell.upvoteButton.tag = indexPath.row - 2;
    cell.upvoteButton.enabled = ![[HNManager sharedManager] hasVotedOnObject:comment];
    cell.replyButton.tag = indexPath.row - 2;
    cell.userButton.tag = indexPath.row - 2;
    
    if ([self.expandedIndexPath isEqual:indexPath]) {
        [cell setExpanded:YES animated:NO];
    } else {
        [cell setExpanded:NO animated:NO];
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0.0f, 15.0f + (comment.Level * 15.0f), 0.0f, 0.0f);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static HFPostInfoTableViewCell *postInfoMetricsCell;

        if (!postInfoMetricsCell) {
            postInfoMetricsCell = [tableView dequeueReusableCellWithIdentifier:kPostInfoTableViewCellIdentifier];
        }
        
        CGRect frame = postInfoMetricsCell.frame;
        frame.size.width = self.tableView.bounds.size.width;
        postInfoMetricsCell.frame = frame;
        
        postInfoMetricsCell.titleLabel.text = self.post.Title;
        postInfoMetricsCell.infoLabel.text = [NSString stringWithFormat:@"%d points · %@", self.post.Points, self.post.TimeCreatedString];
        
        // Force a layout.
        [postInfoMetricsCell layoutSubviews];
        
        // Get the layout size - we ignore the width - in the fact the width _could_ conceivably be zero.
        // Note: Using content view is intentional.
        CGSize theSize = [postInfoMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return (theSize.height + 1);
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
        
        CGRect theFrame = commentMetricsCell.frame;
        theFrame.size.width = self.tableView.bounds.size.width;
        //commentMetricsCell.frame = theFrame;
        
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
        
        // NSLog(@"%@", comment.Text);
        // NSLog(@"%@", NSStringFromCGSize(commentMetricsCell.textView.intrinsicContentSize));
        
        // Get the layout size - we ignore the width - in the fact the width _could_ conceivably be zero.
        // Note: Using content view is intentional.
        CGSize size = [commentMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        CGFloat cellHeight = size.height + 1;
        
        // If the cell isn't expanded, cache the row height
        if (![indexPath isEqual:self.expandedIndexPath]) {
            self.commentCellHeightCache[@(indexPath.row)] = @(cellHeight);
        }
        
        return cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
