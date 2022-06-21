//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>


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
    
    // clear ackess tokens
    [[APIManager shared] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // refresh capability
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
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
    button.backgroundColor = [UIColor colorWithRed:25.0f/255.0f
        green:155.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    
    button.tintColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (@available(iOS 13.0, *)) {
        UIImage *plus = [UIImage systemImageNamed:@"plus"];
        [button setImage:plus forState: UIControlStateNormal];
        NSLog(@"%@", plus);
    }
    button.layer.shadowRadius = 10;
    button.layer.cornerRadius = 30;
    button.layer.shadowOpacity = 0.3;
    
    [self.view addSubview:button];
}

- (void) onComposeTweetPress:(UIButton *)composeTweetButton {
    [self performSegueWithIdentifier:@"triggerComposeTweetView" sender:composeTweetButton];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.authorName.text = tweet.user.name;
    cell.authorHandle.text = tweet.user.screenName;
    cell.tweetDate.text = tweet.createdAtString;
    cell.tweetText.text = tweet.text;
    cell.favoriteCount.text = [@(tweet.favoriteCount) stringValue];
    cell.retweetCount.text = [@(tweet.retweetCount) stringValue];
    
    cell.profilePicture.image = [TimelineViewController imageFromUrl:tweet.user.profilePicture];
    
    //make image circular
    cell.profilePicture.layer.masksToBounds = false;
    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width/2;
    cell.profilePicture.clipsToBounds = true;
    
    return cell;
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
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}

// makes new tweets appear in timeline
- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    NSLog(@"%@", tweet);
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
