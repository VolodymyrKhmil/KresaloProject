//
//  TwitterManager.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/17/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PTKTwitterManager.h"

#import "PTKTwitterApiManager.h"
#import "PTKTwitterUIManager.h"
#import "PTKTwitterDatabaseManager.h"

#import "PTKUniqueMutableArray.h"


static NSInteger const tweetsRequestBlockCount = 20;


@interface PTKTwitterManager ()

@property (nonatomic, strong, readonly) PTKTwitterApiManager *apiManager;
@property (nonatomic, strong, readonly) PTKTwitterUIManager *uiManager;
@property (nonatomic, strong, readonly) PTKTwitterDatabaseManager *databaseManager;

@property (nonatomic, copy) void (^authorizationCallback)(BOOL, NSError*);

@property (nonatomic, strong) PTKUniqueMutableArray *tweets;

@end


@implementation PTKTwitterManager


#pragma mark singelton
+ (instancetype)sharedManager {
    static PTKTwitterManager *sharedInstance;
    
    static dispatch_once_t PTKTwitterSharedManagerDispatchToken;
    dispatch_once(&PTKTwitterSharedManagerDispatchToken, ^{
        sharedInstance = [[super alloc] initSharedInstance];
    });

    return sharedInstance;
}

- (instancetype)initSharedInstance {
    self = [super init];
    if (self != nil) {
        _apiManager = [PTKTwitterApiManager new];
        _uiManager = [PTKTwitterUIManager new];
        _databaseManager = [PTKTwitterDatabaseManager sharedManager];
    }
    return self;
}


#pragma  mark authorization part
- (void)authorizeWithCallback:(void (^)(BOOL, NSError *))callback {
    if (self.delegate != nil) {
        self.authorizationCallback = callback;
        UIViewController *authorizationOptionsController = [self.uiManager authorizationOptionsViewControllerWithPinEnterHandler:^{
            [self startPinEntering];
        } andAuthorizeHandler:^{
            [self startAuthorization];
        }];
        [self.delegate twitterManagerNeedToPresentViewController:authorizationOptionsController];
    }
}

- (void)startAuthorization {
    [self.apiManager requestAuthorizationURLWithCallback:^(BOOL success, NSURL *authorezationURL, NSError *error) {
        if (self.delegate != nil) {
            if (success && authorezationURL != nil) {
                NSURLRequest *request = [NSURLRequest requestWithURL:authorezationURL];
                __block UIViewController *webPageViewController = [self.uiManager webPageViewControllerForRequest:request requestsHandler:^(NSURLRequest * request) {
                    NSString *verifier = [self.apiManager verifierFromCallbackRequest:request];
                    if (verifier != nil) {
                        [webPageViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                        [self setupVerifierAndRequestAccessToken:verifier];
                    }
                }];
                [self.delegate twitterManagerNeedToPresentViewController:webPageViewController];
            } else {
                [self callAuthorizationCallbackWithSuccess:NO error:error];
            }
        }
    }];
}

- (void)startPinEntering {
    if (self.delegate != nil) {
        UIViewController *pinEnteringViewController = [self.uiManager pinEnteringViewControllerWithPinHandler:^(NSString *pin) {
            [self setupVerifierAndRequestAccessToken:pin];
        }];
        [self.delegate twitterManagerNeedToPresentViewController:pinEnteringViewController];
    }
}

- (void)setupVerifierAndRequestAccessToken:(NSString *)verifier {
    [self.apiManager requestAccessTokenWithVerifier:verifier andCallback:^(BOOL success, NSError *error) {
        [self callAuthorizationCallbackWithSuccess:success error:error];
    }];
}


- (void)callAuthorizationCallbackWithSuccess:(BOOL)success error:(NSError *)error {
    if (self.authorizationCallback != nil) {
        self.authorizationCallback(success, error);
        self.authorizationCallback = nil;
    }
}


#pragma mark data based methods
- (NSInteger)count {
    return self.tweets == nil ? 0 : self.tweets.count;
}

- (PTKTweet *)twittAtIndex:(NSInteger)index {
    if (self.tweets != nil && self.tweets.count > index) {
        return [self.tweets objectAtIndex:index];
    } else {
        return nil;
    }
}

#pragma mark tweets updating
- (void)updateTweetsWithCallback:(void (^)(BOOL, NSError *))callback {
    NSDate *start = [NSDate date];
    if (self.tweets == nil) {
        NSArray *allLocalTweets = [self.databaseManager allTweets];
        self.tweets = [[PTKUniqueMutableArray alloc] initWithArray:allLocalTweets];
    }
    
    
    PTKTweet *lastTweet = self.tweets.firstObject;
    NSNumber *count = lastTweet == nil ? @(tweetsRequestBlockCount) : nil;
    [self.apiManager requestTweetsSinceLastTweet:lastTweet
                                      withCount:count
                                    andCallback:^(BOOL success, NSArray *tweets, NSError *error) {
                                        if (success && tweets != nil) {
                                            
                                            [self.tweets addToFrontObjectsFromArray:tweets];
                                            
                                            [self.databaseManager saveTweets:tweets];
                                            callback(YES, nil);
                                        } else {
                                            callback(NO, error);
                                        }
                                        _canTryLoadMore = YES;
                                    }];
}


#pragma mark tweets uploading
- (void)loadMoreTwittsWithCallback:(void (^)(BOOL, NSError *))callback {
    PTKTweet *lastTweet = self.tweets == nil ? nil : (PTKTweet *)self.tweets.lastObject;
    [self.apiManager requestEarlierTweetsThanTweet:lastTweet
                                      withCount:@(tweetsRequestBlockCount)
                                    andCallback:^(BOOL success, NSArray *tweets, NSError *error) {
                                        if (success && tweets != nil) {
                                            NSInteger lastCount = self.tweets.count;
                                            [self.tweets addObjectsFromArray:tweets];
                                            NSInteger newCount = self.tweets.count;
                                            _canTryLoadMore = (newCount - lastCount) > 0;
                                            
                                            [self.databaseManager saveTweets:tweets];
                                            callback(YES, nil);
                                        } else {
                                            callback(NO, error);
                                        }
                                    }];
}

#pragma  mark tweets adding part
- (void)addTweet:(NSString *)tweet withCallback:(void (^)(BOOL, NSError *))callback {
    PTKTwitterManager *selfCopy = self;
    [self.apiManager addTweet:tweet withCallback:^(BOOL success, PTKTweet *tweet, NSError *error) {
        if (success && tweet != nil) {
            [selfCopy.tweets addToFrontObject:tweet];
        }
        if (callback != nil) {
            callback(success, error);
        }
    }];
}

@end
