//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
#import "User.h"

@interface APIManager : BDBOAuth1SessionManager

@property (nonatomic, strong) User *loggedInUser;

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)toggleFavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;
- (void)toggleRetweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;

- (void)getUserTimeLineWithCompletion:(User *)user completion:(void(^)(NSArray *tweets, NSError *error))completion;
@end
