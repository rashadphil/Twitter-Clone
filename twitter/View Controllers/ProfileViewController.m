//
//  ProfileViewController.m
//  twitter
//
//  Created by Rashad Philizaire on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "TimelineViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "DateTools.h"
#import "Media.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileBanner;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *profileDescription;
@property (weak, nonatomic) IBOutlet UILabel *joinDate;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    User * user = self.user;
    self.profileBanner.image = [TimelineViewController imageFromUrl:user.profileBanner];
    self.profilePicture.image = [TimelineViewController imageFromUrl:user.profilePicture];
    self.username.text = user.name;
    self.userHandle.text = user.screenName;
    self.profileDescription.text = user.profileDescription;
    self.followerCount.text = [@(user.followersCount) stringValue];
    self.followingCount.text = [@(user.friendsCount) stringValue];
    
    [self.profilePicture.layer setCornerRadius:28];
    
    [self fetchUserTweets];
    
}

- (void) fetchUserTweets {
    [[APIManager shared] getUserTimeLineWithCompletion:self.user completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [tweets mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.authorName.text = tweet.user.name;
    cell.authorHandle.text = tweet.user.screenName;

    cell.tweetDate.text = [TimelineViewController dateStringToTimeAgo:tweet.createdAtString];
    cell.tweetText.text = tweet.text;

    tweet.user.verified ? [cell.verifiedView setHidden:false] : [cell.verifiedView setHidden:true];

    // update favorite/retweet counts and color appropriately
    [cell refreshData];

    cell.profilePicture.image = [TimelineViewController imageFromUrl:tweet.user.profilePicture];

    //make image circular
    cell.profilePicture.layer.masksToBounds = false;
    [cell.profilePicture.layer setCornerRadius:25];
    cell.profilePicture.clipsToBounds = true;

//    cell.delegate = self;

    [self insertMediaFromTweetCell:cell];
//
    return cell;
}

- (void)insertMediaFromTweetCell:(TweetCell *)cell {
    // insert any media (starting with only one)
    NSArray *allMedia = cell.tweet.entity.mediaArray;
    if (allMedia.count) {
        Media *media = allMedia[0];
        UIImage *mediaImg = [TimelineViewController imageFromUrl:media.mediaUrl];
        cell.mediaImgView.image = mediaImg;
        [cell.mediaImgView.layer setCornerRadius:20.0];
    } else {
        [cell.mediaImgView setAutoresizingMask:UIViewAutoresizingNone];
        cell.mediaImgView.image = nil;
    }
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
