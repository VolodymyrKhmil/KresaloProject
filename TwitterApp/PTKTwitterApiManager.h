//
//  PTKTwitterClient.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PTKTwitterApiManager : NSObject

- (void)requestAuthorizationURLWithCallback:(void (^)(BOOL success, NSURL *authorezationURL, NSError *error))callback;

- (void)requestAccessTokenWithVerifier:(NSString *)verifier andCallback:(void (^)(BOOL success, NSError *error))callback;

- (void)requestTwittsWithCallback:(void (^)(BOOL success, NSArray *twitts, NSError *error))callback;

- (NSString *)verifierFromCallbackRequest:(NSURLRequest *)request;

@end
