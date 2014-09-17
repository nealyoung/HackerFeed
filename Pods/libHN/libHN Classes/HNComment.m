// Copyright (C) 2013 by Benjamin Gordon
//
// Permission is hereby granted, free of charge, to any
// person obtaining a copy of this software and
// associated documentation files (the "Software"), to
// deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall
// be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "HNComment.h"
#import "HNCommentLink.h"
#import "HNUtilities.h"

@implementation HNComment

#pragma mark - Parse Comments
+ (NSArray *)parsedCommentsFromHTML:(NSString *)html forPost:(HNPost *)post {
    // Set Up
    NSMutableArray *comments = [@[] mutableCopy];
    NSString *trash = @"";
    NSArray *htmlComponents = [html componentsSeparatedByString:@"<td><img src=\"s.gif\""];
    
    if (post.type == HNPostTypeAskHN) {
        // Grab AskHN Post
        NSScanner *scanner = [NSScanner scannerWithString:htmlComponents[0]];
        NSString *text = @"", *user = @"", *timeAgo = @"", *commentId = @"", *upvoteUrl = @"";
        
        // Check for Upvote
        if ([htmlComponents[0] rangeOfString:@"dir=\"up"].location != NSNotFound) {
            [scanner scanBetweenString:@"<center><a " andString:@"href" intoString:&trash];
            [scanner scanBetweenString:@"href=\"" andString:@"whence" intoString:&upvoteUrl];
            upvoteUrl = [upvoteUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
        
        // Get Id
        [scanner scanBetweenString:@"<span id=\"score_" andString:@">" intoString:&commentId];
        
        // Get User
        [scanner scanBetweenString:@"by <a href=\"user?id=" andString:@"\">" intoString:&user];
        
        // Get Time Created String
        [scanner scanBetweenString:@"</a> " andString:@"ago" intoString:&timeAgo];
        timeAgo = [timeAgo stringByAppendingString:@"ago"];
        
        // Get Text
        [scanner scanBetweenString:@"</tr><tr><td></td><td>" andString:@"</td>" intoString:&text];
        
        // Get rid of special text crap
        if ([text rangeOfString:@"<form method=\"post"].location != NSNotFound) {
            text = @"";
        }
        
        // Create special comment for it
        HNComment *newComment = [[HNComment alloc] init];
        newComment.level = 0;
        newComment.username = user;
        newComment.createdAtString = timeAgo;
        newComment.text = [HNUtilities stringByReplacingHTMLEntitiesInText:text];
        newComment.links = [HNCommentLink linksFromCommentText:newComment.text];
        newComment.Type = HNCommentTypeAskHN;
        newComment.upvoteURLAddition = upvoteUrl.length>0 ? upvoteUrl : nil;
        newComment.commentId = commentId;
        [comments addObject:newComment];
    }
    
    if (post.type == HNPostTypeJobs) {
        // Grab Jobs Post
        NSScanner *scanner = [NSScanner scannerWithString:htmlComponents[0]];
        NSString *text = @"";
        [scanner scanBetweenString:@"</tr><tr><td></td><td>" andString:@"</td>" intoString:&text];
        
        // Create special comment for it
        HNComment *newComment = [[HNComment alloc] init];
        newComment.level = 0;
        newComment.text = [HNUtilities stringByReplacingHTMLEntitiesInText:text];
        newComment.links = [HNCommentLink linksFromCommentText:newComment.text];
        newComment.Type = HNCommentTypeJobs;
        [comments addObject:newComment];
    }
    
    for (int xx = 1; xx < htmlComponents.count; xx++) {
        // 1st and Last object are garbage.
        if (xx == htmlComponents.count - 1) {
            break;
        }
        
        // Set Up
        NSScanner *scanner = [NSScanner scannerWithString:htmlComponents[xx]];
        HNComment *newComment = [[HNComment alloc] init];
        NSString *level = @"";
        NSString *user = @"";
        NSString *text = @"";
        NSString *timeAgo = @"";
        NSString *reply = @"";
        NSString *commentId = @"";
        NSString *upvoteString = @"";
        NSString *downvoteString = @"";
        
        // Get Comment Level
        [scanner scanBetweenString:@"height=\"1\" width=\"" andString:@">" intoString:&level];
        newComment.level = [level intValue] / 40;
        
        // If Logged In - Grab Voting Strings
        if ([htmlComponents[xx] rangeOfString:@"dir=up"].location != NSNotFound) {
            // Scan Upvote String
            [scanner scanBetweenString:@"href=\"" andString:@"whence" intoString:&upvoteString];
            newComment.upvoteURLAddition = [upvoteString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
            // Check for downvote String
            if ([htmlComponents[xx] rangeOfString:@"dir=down"].location != NSNotFound) {
                [scanner scanBetweenString:@"href=\"" andString:@"whence" intoString:&downvoteString];
                newComment.downvoteURLAddition = [downvoteString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            }
        }
        
        // Get Username
        [scanner scanBetweenString:@"<a href=\"user?id=" andString:@"\">" intoString:&user];
        newComment.username = user.length > 0 ? user : @"[deleted]";
        
        // Get Date/Time Label
        [scanner scanBetweenString:@"</a> " andString:@" |" intoString:&timeAgo];
        newComment.createdAtString = timeAgo;
        
        // Get Comment Text
        [scanner scanBetweenString:@"<font color=" andString:@">" intoString:&trash];
        [scanner scanBetweenString:@">" andString:@"</font>" intoString:&text];
        newComment.text = [HNUtilities stringByReplacingHTMLEntitiesInText:text];
        
        // Get CommentId
        [scanner scanBetweenString:@"reply?id=" andString:@"&" intoString:&commentId];
        newComment.commentId = commentId;
        
        // Get Reply URL Addition
        [scanner scanBetweenString:@"<font size=1><u><a href=\"" andString:@"\">reply" intoString:&reply];
        newComment.replyURLString = reply;
        
        // Get Links
        newComment.links = [HNCommentLink linksFromCommentText:newComment.text];
        
        // Save Comment
        [comments addObject:newComment];
    }
    
    return comments;
}

@end
