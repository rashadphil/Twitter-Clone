//
//  Media.h
//  twitter
//
//  Created by Rashad Philizaire on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Media : NSObject

@property (nonatomic, strong) NSString *mediaUrl;

+ (NSMutableArray *)mediaWithArray:(NSArray *)dictionaries;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
