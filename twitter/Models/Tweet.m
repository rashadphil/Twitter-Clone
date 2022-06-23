//
//  Tweet.m
//  twitter
//
//  Created by Rashad Philizaire on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "DateTools.h"
#import "Media.h"

@implementation Tweet

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

+ (NSString *)extractTextFromHtmlTag:(NSString *)htmlTag {
    NSArray *components = [htmlTag componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    return components[2];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        // Is Retweet?
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.replyCount = [dictionary[@"reply_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.source = [Tweet extractTextFromHtmlTag: dictionary[@"source"]];
        self.entity = [[Entity alloc] initWithDictionary:dictionary[@"entities"]];
        
        //initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        //format date
        self.createdAtString = dictionary[@"created_at"];
        NSLog(@"%@", self.createdAtString);
        
    }
    return self;
}

@end
