//
//  PTKTwitterUIManager.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PTKTwitterUIManager : NSObject <UIWebViewDelegate>

- (UIViewController *)authorizationOptionsViewControllerWithPinEnterHandler:(void (^)())pinEnterHandler andAuthorizeHandler:(void (^)())authorizeHandler;

- (UIViewController *)webPageViewControllerForRequest:(NSURLRequest *)request requestsHandler:(void (^)(NSURLRequest *request))handler;

- (UIViewController *)pinEnteringViewControllerWithPinHandler:(void (^)(NSString *pin))pinHandler;

@end
