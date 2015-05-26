//
//  UIColor+ToString.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 5/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (ToString)

- (NSString *)stringValue;
+ (UIColor *)colorWithString:(NSString *)colorString;

@end
