//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#define TWITTERBLUE [UIColor colorWithRed:25.0f/255.0f green:155.0f/255.0f blue:239.0f/255.0f alpha:1.0f]

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "DateTools.h"
#import "Media.h"
#import <ResponsiveLabel.h>

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate>


@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (IBAction)didTapLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    // changes the storyboard main view to login screen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // clear acess tokens
    [[APIManager shared] logout];
}

// for loading profile view
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    [self performSegueWithIdentifier:@"triggerProfileView" sender:user];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // refresh capability
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self fetchTimeline];
    [self configureCreateTweetButton];
}

- (void) fetchTimeline {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [tweets mutableCopy];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)configureCreateTweetButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onComposeTweetPress:)    forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height - 130, 60, 60);
    
    // twitter color
    button.backgroundColor = TWITTERBLUE;
    
    button.tintColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (@available(iOS 13.0, *)) {
        UIImage *plus = [UIImage systemImageNamed:@"plus"];
        [button setImage:plus forState: UIControlStateNormal];
    }
    button.layer.shadowRadius = 10;
    button.layer.cornerRadius = 30;
    button.layer.shadowOpacity = 0.3;
    
    [self.view addSubview:button];
}

- (void) onComposeTweetPress:(UIButton *)composeTweetButton {
    [self performSegueWithIdentifier:@"triggerComposeTweetView" sender:composeTweetButton];
}

+ (NSString *)dateStringToTimeAgo:(NSString *)originalDateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    //convert string to date
    NSDate *date = [formatter dateFromString:originalDateStr];
    NSString *ago = [date shortTimeAgoSinceNow];
    return ago;
    
}

+ (void)detectUserHandles:(ResponsiveLabel *)label{
//    label.userInteractionEnabled = YES;
    PatternTapResponder handleTapAction = ^(NSString *tappedString) {
        NSLog(@"Handle Tapped = %@",tappedString);
    };
    [label enableUserHandleDetectionWithAttributes:
    @{NSForegroundColorAttributeName:TWITTERBLUE, RLTapResponderAttributeName:handleTapAction}];
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
    
    // colors @handle but causes layout issues :(
    //    [TimelineViewController detectUserHandles:cell.tweetText];
    
    // update favorite/retweet counts and color appropriately
    [cell refreshData];

    cell.profilePicture.image = [TimelineViewController imageFromUrl:tweet.user.profilePicture];
    
    //make image circular
    cell.profilePicture.layer.masksToBounds = false;
    [cell.profilePicture.layer setCornerRadius:25];
    cell.profilePicture.clipsToBounds = true;
    
    cell.delegate = self;
    
    [self insertMediaFromTweetCell:cell];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

+ (UIImage * )imageFromUrl:(NSString*)URLString {
    NSURL* url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:urlData];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchTimeline];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // three possible senders -> Compose Button, Tweet Cell, User Profile
    if ([[segue identifier] isEqualToString:@"triggerComposeTweetView"]) {
        
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
    } else if ([[segue identifier] isEqualToString:@"triggerTweetDetailView"]) {
        NSIndexPath* index = [self.tableView indexPathForCell:sender];
        Tweet* tweet = self.arrayOfTweets[index.row];
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.tweet = tweet;
        
    } else if ([[segue identifier] isEqualToString:@"triggerProfileView"]) {
        User *user = sender;
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = user;
        
    }
}

// makes new tweets appear in timeline
- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
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
