//
//  PTKTwitterUIManager.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTwitterUIManager.h"

#import "PTKWebViewController.h"

static NSString * const PTKEnterPinTitle = @"Enter PIN";
static NSString * const PTKAuthorizeTitle = @"Authorize";

@interface PTKTwitterUIManager ()

@property (nonatomic, copy) void (^webPageRequestsHandler)(NSURLRequest *);

@end

@implementation PTKTwitterUIManager

- (UIViewController *)authorizationOptionsViewControllerWithPinEnterHandler:(void (^)())pinEnterHandler andAuthorizeHandler:(void (^)())authorizeHandler {
    UIAlertAction *enterPinAction   = [UIAlertAction actionWithTitle:PTKEnterPinTitle style:UIAlertActionStyleDefault handler:^ (UIAlertAction *action) {
        if (pinEnterHandler != nil) { pinEnterHandler(); }
    }];
    UIAlertAction *authorizeAction  = [UIAlertAction actionWithTitle:PTKAuthorizeTitle style:UIAlertActionStyleDefault handler:^ (UIAlertAction *action) {
        if (authorizeHandler != nil) { authorizeHandler(); }
    }];
    UIAlertAction *cancelAction     = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:enterPinAction];
    [alertController addAction:authorizeAction];
    [alertController addAction:cancelAction];
    return alertController;
}


- (UIViewController *)webPageViewControllerForRequest:(NSURLRequest *)request requestsHandler:(void (^)(NSURLRequest *))handler {
    self.webPageRequestsHandler = handler;
    PTKWebViewController *webViewController = [PTKWebViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissWebViewController)];
    webViewController.navigationItem.leftBarButtonItem = doneButton;
    [webViewController loadView];
    webViewController.webView.delegate = self;
    [webViewController.webView loadRequest:request];
    return navigationController;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.webPageRequestsHandler != nil) {
        self.webPageRequestsHandler(request);
    }
    
    return YES;
}

- (void)dismissWebViewController {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)pinEnteringViewControllerWithPinHandler:(void (^)(NSString *))pinHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:PTKEnterPinTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"PIN";
    }];
    
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (pinHandler != nil) {
            NSString *pin = ((UITextField *)alertController.textFields.firstObject).text;
            pinHandler(pin);
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:enterAction];
    
    return alertController;
}

@end
