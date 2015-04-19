//
//  PTKErrorHandler.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/19/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKErrorHandler.h"
#import <UIKit/UIKit.h>

@implementation PTKErrorHandler

+ (void)handleError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];
}

@end
