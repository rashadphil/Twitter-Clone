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
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)twitterFormattedNumber:(NSString *)numberString{
    double number = [numberString doubleValue];
    double thousand = number / 1000;
    double million = number / (1000 * 1000);
    if (million >= 1) {
        return [[@(round(million * 10)/10) stringValue] stringByAppendingString:@"M"];
    } else if (thousand >= 1) {
        return [[@(round(thousand * 10)/10) stringValue] stringByAppendingString:@"K"];
    } else {
        return numberString;
    }
        
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate tweetCell:self didTap:self.tweet.user];
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

- (NSAttributedString* )createAttributedString:(NSString* )str {
    UIFont * labelFont = [UIFont fontWithName:@"Helvetica" size:14];
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString : str
                attributes : @{
                 NSFontAttributeName : labelFont}];
    return labelText;
}

- (void)updateRetweetInfo{
    // update count
    NSString *formatedCountString = [TweetCell twitterFormattedNumber:[@(self.tweet.retweetCount) stringValue]];
    NSAttributedString *retweetCount = [self createAttributedString:formatedCountString];
    
    [self.retweetButton setAttributedTitle:retweetCount forState:UIControlStateNormal];
    [self.retweetButton setTintColor:(self.tweet.retweeted ? [UIColor systemGreenColor] : [UIColor grayColor])];
}

- (void)updateFavoriteInfo{
    
    NSString *formatedCountString = [TweetCell twitterFormattedNumber:[@(self.tweet.favoriteCount) stringValue]];
    NSAttributedString *favoriteCount = [self createAttributedString:formatedCountString];
    
    [self.favoriteButton setAttributedTitle:favoriteCount forState:UIControlStateNormal];
    
    //update color
    UIImage *filledFavorite = [UIImage systemImageNamed:@"heart.fill"];
    UIImage *redFavorite = [filledFavorite imageWithTintColor:[UIColor systemRedColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unfilledFavorite = [UIImage systemImageNamed:@"heart"];
    [self.favoriteButton setImage:self.tweet.favorited ? redFavorite : unfilledFavorite forState:UIControlStateNormal];
    [self.favoriteButton setTintColor:(self.tweet.favorited ? [UIColor systemRedColor] : [UIColor grayColor])];
}

@end
