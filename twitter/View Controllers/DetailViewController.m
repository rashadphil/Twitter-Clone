//
//  DetailViewController.m
//  twitter
//
//  Created by Rashad Philizaire on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "TimelineViewController.h"
#import "APIManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorHandle;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *postTime;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *postSource;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailViewController

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


- (void)refreshData{
    
    [self updateFavoriteInfo];
    [self updateRetweetInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Tweet * tweet = self.tweet;
    self.authorName.text = tweet.user.name;
    self.authorHandle.text = tweet.user.screenName;
    self.tweetText.text = tweet.text;
    self.profilePicture.image = [TimelineViewController imageFromUrl:tweet.user.profilePicture];
    self.postTime.text = [self postTimeFromTweet];
    self.postSource.text = tweet.source;
    self.retweetCount.text = [@(tweet.retweetCount) stringValue];
    self.likeCount.text = [@(tweet.favoriteCount) stringValue];
}

- (NSString *)postTimeFromTweet {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    //convert string to hours
    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
    formatter.dateFormat = @"HH:mm a";
    return [formatter stringFromDate:date];
}

- (NSString *)postDateFromTweet {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    //convert string to hours
    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
    formatter.dateFormat = @"d/m/y";
    return [formatter stringFromDate:date];
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
    self.retweetCount.text = [@(self.tweet.retweetCount) stringValue];
    [self.retweetButton setTintColor:(self.tweet.retweeted ? [UIColor systemGreenColor] : [UIColor grayColor])];
}

- (void)updateFavoriteInfo{
    // update count
    self.likeCount.text = [@(self.tweet.favoriteCount) stringValue];
    
    //update color
    UIImage *filledFavorite = [UIImage systemImageNamed:@"heart.fill"];
    UIImage *redFavorite = [filledFavorite imageWithTintColor:[UIColor systemRedColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unfilledFavorite = [UIImage systemImageNamed:@"heart"];
    [self.likeButton setImage:self.tweet.favorited ? redFavorite : unfilledFavorite forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
