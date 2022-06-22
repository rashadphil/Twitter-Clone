//
//  ComposeViewController.m
//  twitter
//
//  Created by Rashad Philizaire on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "ApiManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation ComposeViewController

- (IBAction)cancelComposeTweet:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)postTweet:(id)sender {
    NSString *postText = self.tweetText.text;
    [[APIManager shared] postStatusWithText:postText completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self dismissViewControllerAnimated:true completion:nil];
            [self.delegate didTweet:tweet];
        } else {
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.text = @"What's happening?";
//    self.tweetText.textColor = [UIColor grayColor];
    self.tweetText.textColor = [UIColor whiteColor];
    
    
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
