//
//  UIColor+ToString.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 5/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "UIColor+ToString.h"

@implementation UIColor (ToString)

- (NSString *)stringValue {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor *)colorWithString:(NSString *)colorString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:colorString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
    
    
}

@end
