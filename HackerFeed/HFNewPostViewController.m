//
//  HFNewPostViewController.m
//  HackerFeed
//
//  Created by Nealon Young on 8/1/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFNewPostViewController.h"

#import "libHN.h"
#import "NYSegmentedControl.h"
#import "HFTextFieldTableViewCell.h"
#import "HFTextViewTableViewCell.h"
#import "SVProgressHUD.h"

@interface HFNewPostViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property NYSegmentedControl *segmentedControl;
@property UITableView *tableView;

@property UITextField *titleTextField;
@property UITextField *urlTextField;
@property UITextView *postTextView;

@end

static NSString * const kTextFieldTableViewCellIdentifier = @"TextFieldTableViewCell";
static NSString * const kTextViewTableViewCellIdentifier = @"TextViewTableViewCell";

@implementation HFNewPostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[HFTextFieldTableViewCell class] forCellReuseIdentifier:kTextFieldTableViewCellIdentifier];
        [self.tableView registerClass:[HFTextViewTableViewCell class] forCellReuseIdentifier:kTextViewTableViewCellIdentifier];
        [self.view addSubview:self.tableView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_tableView)]];
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CloseIcon"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(cancelButtonPressed:)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SubmitIcon"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(submitButtonPressed:)];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Link", nil), NSLocalizedString(@"Text", nil)]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.segmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    self.segmentedControl.segmentIndicatorInset = 0.0f;
    self.segmentedControl.titleTextColor = [UIColor lightGrayColor];
    self.segmentedControl.selectedTitleTextColor = [UIColor darkGrayColor];
    self.segmentedControl.selectedTitleFont = [UIFont semiboldApplicationFontOfSize:14.0f];
    self.segmentedControl.titleFont = [UIFont applicationFontOfSize:14.0f];
    [self.segmentedControl sizeToFit];
    self.segmentedControl.cornerRadius = CGRectGetHeight(self.segmentedControl.frame) / 2.0f;
    self.navigationItem.titleView = self.segmentedControl;
}

- (void)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitButtonPressed:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [[HNManager sharedManager] submitPostWithTitle:self.titleTextField.text
                                                  link:self.urlTextField.text
                                                  text:nil
                                            completion:^(BOOL success) {
                                                if (success) {
                                                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Link submitted", nil)];
                                                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                } else {
                                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting link", nil)];
                                                }
                                            }];
    } else {
        [[HNManager sharedManager] submitPostWithTitle:self.titleTextField.text
                                                  link:nil
                                                  text:self.postTextView.text
                                            completion:^(BOOL success) {
                                                if (success) {
                                                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Post submitted", nil)];
                                                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                                } else {
                                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error submitting post", nil)];
                                                }
                                            }];
    }
}

- (void)segmentSelected:(NYSegmentedControl *)sender {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        if (indexPath.row == 0) {
            HFTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextFieldTableViewCellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = NSLocalizedString(@"Title", nil);
            cell.textField.placeholder = NSLocalizedString(@"Show HN: My App", nil);
            self.titleTextField = cell.textField;
            return cell;
        } else {
            HFTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextFieldTableViewCellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = NSLocalizedString(@"URL", nil);
            cell.textField.placeholder = NSLocalizedString(@"http://example.com", nil);
            self.urlTextField = cell.textField;
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            HFTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextFieldTableViewCellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = NSLocalizedString(@"Title", nil);
            
            return cell;
        } else {
            HFTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextViewTableViewCellIdentifier forIndexPath:indexPath];
            cell.textView.delegate = self;
            cell.textView.editable = YES;
            cell.textView.placeholder = NSLocalizedString(@"Post text", nil);
            self.postTextView = cell.textView;
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return 44.0f;
    } else {
        if (indexPath.row == 0) {
            return 44.0f;
        } else {
            static HFTextViewTableViewCell *textViewMetricsCell;
            
            if (!textViewMetricsCell) {
                textViewMetricsCell = [tableView dequeueReusableCellWithIdentifier:kTextViewTableViewCellIdentifier];
            }
            
            textViewMetricsCell.bounds = CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 9999.0f);
            textViewMetricsCell.textView.text = self.postTextView.text;
            [textViewMetricsCell setNeedsLayout];
            [textViewMetricsCell layoutIfNeeded];
            
            // Get the actual height required for the cell
            CGFloat height = [textViewMetricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            
            // Add an extra point to the height to account for the cell separator, which is added between the bottom of the cell's contentView and the bottom of the table view cell.
            height += 1;
            
            return height;
        }
    }
}

# pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Trigger an update of cell heights so the text view can add a new line if needed
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    } else {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        return YES;
    }
}

@end
