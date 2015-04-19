//
//  PTKTwitterClient.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTwitterApiManager.h"

#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OADataFetcher.h"

#import "NSMutableURLRequest+HTTPMethod.h"

#import "PTKTwitt.h"
#import "PTKURLParser.h"
#import "FXKeychain.h"

static NSString * const PTKConsumerKey      = @"CmHWYbQ4C3JPimlJDeYmji2Ot";
static NSString * const PTKConsumerSecret   = @"TrhjY3MwFTSWXmIhNflQ0ufvAOuR3GrdXoOEn3hTbGZtyzjTJA";
static NSString * const PTKAccessTokenKey   = @"ptk_access_token";


@interface PTKTwitterApiManager ()

@property (nonatomic, strong) OAToken *accessToken;

@property (nonatomic, copy) void (^authorezationURLRequestCallback)(BOOL , NSURL *, NSError *);
@property (nonatomic, copy) void (^accessTokenRequestCallback)(BOOL, NSError *);
@property (nonatomic, copy) void (^twittsRequestCallback)(BOOL, NSArray *, NSError *);

@end




@implementation PTKTwitterApiManager
#pragma  mark access token saving
- (void)saveAccessToken {
    FXKeychain *keychain = [FXKeychain defaultKeychain];
    [keychain setObject:[NSKeyedArchiver archivedDataWithRootObject:self.accessToken] forKey:PTKAccessTokenKey];
}

- (OAToken *)savedAccessToken {
    FXKeychain *keychain = [FXKeychain defaultKeychain];
    NSData *accessTokenData = (NSData *)[keychain objectForKey:PTKAccessTokenKey];
    if (accessTokenData == nil) {
        return nil;
    }
    OAToken *accessToken = (OAToken *)[NSKeyedUnarchiver unarchiveObjectWithData:accessTokenData];
    return accessToken;
}

#pragma  mark request authorization
- (void)requestAuthorizationURLWithCallback:(void (^)(BOOL success, NSURL *authorezationURL, NSError *error))callback {
    self.authorezationURLRequestCallback = callback;
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:PTKConsumerKey
                                                    secret:PTKConsumerSecret];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    [request setPTKHTTPMethod:PTKHTTPMethodPost];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        
        NSString *address = [NSString stringWithFormat:
                             @"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                             self.accessToken.key];
        
        NSURL *authorizationURL = [NSURL URLWithString:address];
        
        [self callAuthorizationURLCallbackWithSuccess:YES url:authorizationURL error:nil];
    } else {
        [self callAuthorizationURLCallbackWithSuccess:ticket.didSucceed url:nil error:nil];
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    [self callAuthorizationURLCallbackWithSuccess:NO url:nil error:error];
}

- (void)callAuthorizationURLCallbackWithSuccess:(BOOL)success url:(NSURL *)url error:(NSError *)error {
    if (self.authorezationURLRequestCallback != nil) {
        self.authorezationURLRequestCallback(success, url, error);
    }
    self.authorezationURLRequestCallback = nil;
}


#pragma mark request access token with pin

- (void)requestAccessTokenWithVerifier:(NSString *)verifier andCallback:(void (^)(BOOL, NSError *))callback {
    self.accessTokenRequestCallback = callback;
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:PTKConsumerKey
                                                    secret:PTKConsumerSecret];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    [self.accessToken setVerifier:verifier];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:self.accessToken
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    [request setPTKHTTPMethod:PTKHTTPMethodPost];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [self saveAccessToken];
    }
    [self callAccessTokenRequestCallbackWithSuccess:ticket.didSucceed error:nil];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    [self callAccessTokenRequestCallbackWithSuccess:NO error:error];
}

- (void)callAccessTokenRequestCallbackWithSuccess:(BOOL)success error:(NSError *)error {
    if (self.accessTokenRequestCallback != nil) {
        self.accessTokenRequestCallback(success, error);
    }
    self.accessTokenRequestCallback = nil;
}


#pragma mark tweets request

- (void)requestTwittsWithCallback:(void (^)(BOOL, NSArray *, NSError *))callback {
    self.twittsRequestCallback = callback;
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:PTKConsumerKey
                                                    secret:PTKConsumerSecret];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:[self savedAccessToken]
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
}

- (void)apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSArray *parsedArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *tweets = [NSMutableArray new];
        for (NSDictionary *twittData in parsedArray) {
            PTKTwitt *tweet = [[PTKTwitt alloc] initWithDictionary:twittData error:nil];
            [tweets addObject:tweet];
        }
        [self callTwittsRequestCallbackWithSuccess:YES tweets:tweets error:nil];
    } else {
        [self callTwittsRequestCallbackWithSuccess:NO tweets:nil error:nil];
    }
}

- (void)apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    [self callTwittsRequestCallbackWithSuccess:NO tweets:nil error:nil];
}

- (void)callTwittsRequestCallbackWithSuccess:(BOOL)success tweets:(NSArray *)tweets error:(NSError *)error {
    if (self.twittsRequestCallback != nil) {
        self.twittsRequestCallback(success, tweets, error);
    }
    self.twittsRequestCallback = nil;
}

#pragma mark verifier handling
- (NSString *)verifierFromCallbackRequest:(NSURLRequest *)request {
    NSString * const PTKVerifierKey = @"oauth_verifier";
    PTKURLParser *parser = [[PTKURLParser alloc] initWithURLString:request.URL.absoluteString];
    NSString *verifier = [parser valueForVariable:PTKVerifierKey];
    return verifier;
}

@end
