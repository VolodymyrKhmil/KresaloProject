//
//  PTKTwitterClient.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTKTwitt.h"



@interface PTKTwitterApiManager : NSObject

- (void)requestAuthorizationURLWithCallback:(void (^)(BOOL success, NSURL *authorezationURL, NSError *error))callback;

- (void)requestAccessTokenWithVerifier:(NSString *)verifier andCallback:(void (^)(BOOL success, NSError *error))callback;

- (void)requestTweetsFromLastTweet:(PTKTwitt *)lastTweet withCount:(NSNumber *)count andCallback:(void (^)(BOOL, NSArray *, NSError *))callback;

- (void)addTweet:(NSString *)tweet withCallback:(void (^)(BOOL success, PTKTwitt *twitt, NSError *error))callback;

- (NSString *)verifierFromCallbackRequest:(NSURLRequest *)request;

@end
