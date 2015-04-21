//
//  PTKToTweetConverter.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKToTweetConverter.h"

@implementation PTKToTweetConverter

+ (PTKTweet *)tweetFromDictionary:(NSDictionary *)dictionary {
    NSError *error = [NSError new];
    PTKTweet *tweet = [[PTKTweet alloc] initWithDictionary:dictionary error:&error];
    
    tweet.webPageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/statuses/%@", tweet.id.stringValue]];
    tweet.twitterAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@", tweet.id.stringValue]];
    return tweet;
}

@end
