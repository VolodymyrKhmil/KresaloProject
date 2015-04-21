//
//  PTKToTweetConverter.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTKTweet.h"

@interface PTKToTweetConverter : NSObject

+ (PTKTweet *)tweetFromDictionary:(NSDictionary *)dictionary;

@end
