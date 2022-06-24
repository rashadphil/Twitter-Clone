//
//  ComposeViewController.m
//  twitter
//
//  Created by Rashad Philizaire on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "ApiManager.h"
#import "TimelineViewController.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

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

- (void)textViewDidChange:(UITextView *)textView {
    [self.placeholderLabel setHidden:(textView.text.length != 0)];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.delegate = self;
    
    self.tweetText.text = @"";
    User *user = [APIManager shared].loggedInUser;
    self.profilePicture.image = [TimelineViewController imageFromUrl:user.profilePicture];
    [self.profilePicture.layer setCornerRadius:25];
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
