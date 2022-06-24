//
//  User.m
//  twitter
//
//  Created by Rashad Philizaire on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = [@"@" stringByAppendingString:dictionary[@"screen_name"]];
        
        NSString *blurryProfileUrl = dictionary[@"profile_image_url_https"];
        self.profilePicture = [blurryProfileUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                               
        self.profileBanner = dictionary[@"profile_banner_url"];
        self.location = dictionary[@"location"];
        self.profileDescription = dictionary[@"description"];
        self.id = [dictionary[@"id"] intValue];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.friendsCount = [dictionary[@"friends_count"] intValue];
        self.verified = [dictionary[@"verified"] boolValue];
    }
    return self;
}

@end
