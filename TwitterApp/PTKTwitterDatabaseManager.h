//
//  PTKTwitterDatabaseManager.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 5/11/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTKTweet.h"

@interface PTKTwitterDatabaseManager : NSObject

+ (instancetype)sharedManager;


- (void)saveTweets:(NSArray *)tweets;

- (void)saveTweet:(PTKTweet *)tweet;

- (NSArray *)allTweets;

@end
