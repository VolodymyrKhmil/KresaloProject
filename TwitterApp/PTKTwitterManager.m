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
#import "PTKTwitt.h"

@interface PTKTwitterManager ()

@property (nonatomic, strong, readonly) PTKTwitterApiManager *apiManager;
@property (nonatomic, strong, readonly) PTKTwitterUIManager *uiManager;

@property (nonatomic, copy) void (^authorizationCallback)(BOOL, NSError*);

@property (nonatomic, strong) NSArray *twitts;

@end


@implementation PTKTwitterManager


#pragma mark singelton
+ (instancetype)sharedManager {
    static PTKTwitterManager *sharedInstance;
    
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
            sharedInstance = [[super alloc] initSharedInstance];
    });

    return sharedInstance;
}

- (instancetype)initSharedInstance {
    self = [super init];
    if (self != nil) {
        _apiManager = [PTKTwitterApiManager new];
        _uiManager = [PTKTwitterUIManager new];
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
                UIViewController *webPageViewController = [self.uiManager webPageViewControllerForRequest:request requestsHandler:^(NSURLRequest * request) {
                    NSString *verifier = [self.apiManager verifierFromCallbackRequest:request];
                    if (verifier != nil) {
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
    return self.twitts == nil ? 0 : self.twitts.count;
}

- (void)updateTwittsWithCallback:(void (^)(BOOL, NSError *))callback {
    [self.apiManager requestTwittsWithCallback:^(BOOL success, NSArray *twitts, NSError *error) {
        if (success && twitts != nil) {
            self.twitts = twitts;
            callback(YES, nil);
        } else {
            callback(NO, error);
        }
    }];
}

- (PTKTwitt *)twittAtIndex:(NSInteger)index {
    if (self.twitts != nil && self.twitts.count > index) {
        return [self.twitts objectAtIndex:index];
    } else {
        return nil;
    }
}

@end
