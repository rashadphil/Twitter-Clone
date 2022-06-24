//
//  TweetCell.h
//  twitter
//
//  Created by Rashad Philizaire on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import <ResponsiveLabel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImgView;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedView;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

// update favorite/retweet counts and color appropriately
- (void)refreshData;
- (void)sendFavoriteRequest;
- (void)sendUnFavoriteRequest;
- (void)sendRetweetRequest;
- (void)sendUnRetweetRequest;
+ (NSString *)twitterFormattedNumber:(NSString *)numberString;

@end

@protocol TweetCellDelegate
    - (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END
