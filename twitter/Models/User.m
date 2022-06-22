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
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.profileBanner = dictionary[@"profile_banner_url"];
        self.location = dictionary[@"location"];
        self.profileDescription = dictionary[@"description"];
        self.id = [dictionary[@"id"] intValue];
        self.followersCount = [dictionary[@"followersCount"] intValue];
        self.friendsCount = [dictionary[@"friendsCount"] intValue];
    }
    return self;
}

@end
