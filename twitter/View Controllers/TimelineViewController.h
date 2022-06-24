//
//  TimelineViewController.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ResponsiveLabel.h>

@interface TimelineViewController : UIViewController

+ (UIImage * )imageFromUrl:(NSString*)URLString;
+ (void)detectUserHandles:(ResponsiveLabel *)label;
+ (NSString *)dateStringToTimeAgo:(NSString *)originalDateStr;	

@end
