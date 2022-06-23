//
//  Entity.m
//  twitter
//
//  Created by Rashad Philizaire on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Entity.h"
#import "Media.h"

@implementation Entity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *mediaArray = dictionary[@"media"];
        NSMutableArray *media = [Media mediaWithArray:mediaArray];
        self.mediaArray = media;
    }
    return self;
}

@end
