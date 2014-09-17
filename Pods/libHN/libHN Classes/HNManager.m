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

#import "HNManager.h"

@implementation HNManager

// Build the static manager object
static HNManager * _sharedManager = nil;


#pragma mark - Set Up HNManager's Singleton
+ (HNManager *)sharedManager {
	@synchronized([HNManager class]) {
		if (!_sharedManager)
            _sharedManager  = [[HNManager alloc] init];
		return _sharedManager;
	}
	return nil;
}

+ (id)alloc {
	@synchronized([HNManager class]) {
		NSAssert(_sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedManager = [super alloc];
		return _sharedManager;
	}
	return nil;
}

- (instancetype)init {
	if (self = [super init]) {
        // Set up Webservice
        self.service = [[HNWebService alloc] init];
        
        // Set up Voted On Dictionary
        self.votedOnDictionary = [NSMutableDictionary dictionary];
        
        // Set Mark As Read
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HN-MarkAsRead"]) {
            self.markAsReadDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HN-MarkAsRead"] mutableCopy];
        }
        else {
            self.markAsReadDictionary = [NSMutableDictionary dictionary];
        }
	}
	return self;
}

#pragma mark - Start Session
- (void)startSession {
    // Set Values from Defaults
    self.sessionCookie = [HNManager getHNCookie];
    
    // Validate User/Cookie
    [self validateAndSetCookieWithCompletion:^(HNUser *user, NSHTTPCookie *cookie) {
        if (user) {
            self.sessionUser = user;
        }
        else {
            self.sessionUser = nil;
        }
        if (cookie) {
            self.sessionCookie = cookie;
        }
        else {
            self.sessionCookie = nil;
        }
        
        // Post Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoginOrOut" object:nil];
    }];
}


#pragma mark - Set Session Cookie & Username
- (void)setCookie:(NSHTTPCookie *)cookie user:(HNUser *)user {
    // Set Session
    self.sessionUser = user;
    self.sessionCookie = cookie;
}

#pragma mark - Check for Logged In User
- (BOOL)userIsLoggedIn {
    return self.sessionCookie && self.sessionUser;
}

#pragma mark - WebService Methods
- (void)loginWithUsername:(NSString *)user password:(NSString *)pass completion:(SuccessfulLoginBlock)completion {
    [self.service loginWithUsername:user pass:pass completion:^(HNUser *user, NSHTTPCookie *cookie) {
        if (user && cookie) {
            // Set Cookie & User
            [self setCookie:cookie user:user];
            
            // Post Notification
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoginOrOut" object:nil];

            // Pass user on through
            completion(user);
        }
        else {
            completion(nil);
        }
    }];
}

- (void)logout {
    // Delete cookie from Storage
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:self.sessionCookie];
    
    // Delete objects in memory
    self.sessionCookie = nil;
    self.sessionUser = nil;
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoginOrOut" object:nil];
}

- (void)loadUserWithUsername:(NSString *)username completion:(GetUserCompletion)completion {
    [self.service loadUserWithUsername:username completion:completion];
}

- (void)loadPostsWithFilter:(HNPostFilterType)filter completion:(GetPostsCompletion)completion {
    // Reset PostUrlAddition
    self.postUrlAddition = nil;
    
    // Load post
    [self.service loadPostsWithFilter:filter completion:completion];
}

- (void)loadPostsWithUrlAddition:(NSString *)urlAddition completion:(GetPostsCompletion)completion {
    [self.service loadPostsWithUrlAddition:urlAddition completion:completion];
}

- (void)loadCommentsFromPost:(HNPost *)post completion:(GetCommentsCompletion)completion {
    [self.service loadCommentsFromPost:post completion:completion];
}

- (void)submitPostWithTitle:(NSString *)title link:(NSString *)link text:(NSString *)text completion:(BooleanSuccessBlock)completion {
    if ((!link && !text) || !title) {
        // No link and text, or no title - can't submit
        completion(NO);
        return;
    }
    
    // Make the Webservice Call
    [self.service submitPostWithTitle:title link:link text:text completion:completion];
}

- (void)replyToPostOrComment:(id)hnObject withText:(NSString *)text completion:(BooleanSuccessBlock)completion {
    if (!hnObject || !text) {
        // You need a Post/Comment and text to make a reply!
        completion(NO);
        return;
    }
    
    // Make the Webservice call
    [self.service replyToHNObject:hnObject withText:text completion:completion];
}

- (void)voteOnPostOrComment:(id)hnObject direction:(HNVoteDirection)direction completion:(BooleanSuccessBlock)completion {
    if (!(hnObject || direction)) {
        // Must be a Post/Comment and direction to vote!
        completion(NO);
        return;
    }
    
    // Make the Webservice Call
    [self.service voteOnHNObject:hnObject direction:direction completion:completion];
}

- (void)fetchSubmissionsForUser:(NSString *)user completion:(GetPostsCompletion)completion {
    if (!user) {
        // Need a username to get their submissions!
        completion(nil);
        return;
    }
    
    // Make the webservice call
    [self.service fetchSubmissionsForUser:user completion:completion];
}


#pragma mark - Set Cookie & User
- (void)validateAndSetCookieWithCompletion:(LoginCompletion)completion {
    NSHTTPCookie *cookie = [HNManager getHNCookie];
    if (cookie) {
        [self.service validateAndSetSessionWithCookie:cookie completion:completion];
    }
}

+ (NSHTTPCookie *)getHNCookie {
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://news.ycombinator.com/"]];
    if (cookieArray.count > 0) {
        NSHTTPCookie *cookie = cookieArray[0];
        if ([cookie.name isEqualToString:@"user"]) {
            return cookie;
        }
    }
    
    return nil;
}

- (BOOL)isUserLoggedIn {
    return (self.sessionCookie != nil && self.sessionUser != nil);
}


#pragma mark - Mark As Read
- (BOOL)hasUserReadPost:(HNPost *)post {
    return self.markAsReadDictionary[post.postId] ? YES : NO;
}

- (void)setMarkAsReadForPost:(HNPost *)post {
    [self.markAsReadDictionary setObject:@YES forKey:post.postId];
    [[NSUserDefaults standardUserDefaults] setObject:self.markAsReadDictionary forKey:@"HN-MarkAsRead"];
}

#pragma mark - Voted On Dictionary
- (BOOL)hasVotedOnObject:(id)hnObject {
    NSString *votedOnId = [hnObject isKindOfClass:[HNPost class]] ? [(HNPost *)hnObject postId] : [(HNComment *)hnObject commentId];
    return [self.votedOnDictionary objectForKey:votedOnId] != nil ? YES : NO;
}

- (void)addHNObjectToVotedOnDictionary:(id)hnObject direction:(HNVoteDirection)direction {
    NSString *votedOnId = [hnObject isKindOfClass:[HNPost class]] ? [(HNPost *)hnObject postId] : [(HNComment *)hnObject commentId];
    [self.votedOnDictionary setObject:@(direction) forKey:votedOnId];
}

#pragma mark - Cancel Requests
- (void)cancelAllRequests {
    [self.service cancelAllRequests];
}

@end
