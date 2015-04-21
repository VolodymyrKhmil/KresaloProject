//
//  PTKTweetCell.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PTKTweet.h"


@interface PTKTweetCell : UITableViewCell

@property (nonatomic, readonly) PTKTweet *tweet;

@property (nonatomic, readonly) CGFloat preferedHeight;


- (instancetype)initWithTweet:(PTKTweet *)tweet;

@end
