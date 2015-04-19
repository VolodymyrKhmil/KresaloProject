//
//  PTKWEbViewPresentationController.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKWebViewController.h"

@interface PTKWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *internalWebView;

@end


@implementation PTKWebViewController

- (instancetype)init {
    self = [super initWithNibName:@"PTKWebViewController" bundle:[NSBundle mainBundle]];
    return self;
}

- (UIWebView *)webView {
    return self.internalWebView;
}

@end
