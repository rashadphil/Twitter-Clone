//
//  TweetCell.m
//  twitter
//
//  Created by Rashad Philizaire on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        self.tweet.favoriteCount -= 1;
    } else {
        self.tweet.favoriteCount += 1;
    }
    
    self.tweet.favorited = !self.tweet.favorited;
    [self sendToggleFavoriteRequest];
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweetCount -= 1;
    } else {
        self.tweet.retweetCount += 1;
    }
    self.tweet.retweeted = !self.tweet.retweeted;
    [self sendToggleRetweetRequest];
    [self refreshData];
}
- (IBAction)didTapReply:(id)sender {
}

- (void)refreshData{
    
    [self updateFavoriteInfo];
    [self updateRetweetInfo];
    
}
-(void)sendToggleFavoriteRequest{
    [[APIManager shared] toggleFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully toggle favorited the following Tweet: %@", tweet.text);
         }
     }];
}

-(void)sendToggleRetweetRequest{
    [[APIManager shared] toggleRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully toggle favorited the following Tweet: %@", tweet.text);
         }
     }];
}

- (void)updateRetweetInfo{
    // update count
    NSAttributedString *retweetCount = [[NSAttributedString alloc] initWithString:([@(self.tweet.retweetCount) stringValue])];
    [self.retweetButton setAttributedTitle:retweetCount forState:UIControlStateNormal];
    
    //update color
    UIImage *filledRetweet = [UIImage imageNamed:@"retweet-green"];
    UIImage *unfilledRetweet = [UIImage imageNamed:@"retweet"];
    
    [self.retweetButton
     setImage:(self.tweet.retweeted ? filledRetweet : unfilledRetweet) forState:UIControlStateNormal];
}

- (void)updateFavoriteInfo{
    // update count
    NSAttributedString *favoriteCount = [[NSAttributedString alloc] initWithString:([@(self.tweet.favoriteCount) stringValue])];
    [self.favoriteButton setAttributedTitle:favoriteCount forState:UIControlStateNormal];
    
    //update color
    UIImage *filledFavorite = [UIImage imageNamed:@"favorite-red"];
    UIImage *unfilledFavorite = [UIImage imageNamed:@"favorite"];
    [self.favoriteButton setImage:self.tweet.favorited ? filledFavorite : unfilledFavorite forState:UIControlStateNormal];
}

@end
