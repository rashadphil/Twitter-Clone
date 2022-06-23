//
//  Media.m
//  twitter
//
//  Created by Rashad Philizaire on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Media.h"

@implementation Media

+ (NSMutableArray *)mediaWithArray:(NSArray *)dictionaries {
    NSMutableArray *medias = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Media *media = [[Media alloc] initWithDictionary:dictionary];
        [medias addObject:media];
    }
    return medias;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.mediaUrl = dictionary[@"media_url_https"];
    
    return self;
}

@end
