//
//  JSONModelTransformerCategory.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/22/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "JSONModelTransformerCategory.h"

@implementation JSONValueTransformer (UIColor)
- (UIColor *)UIColorFromNSString:(NSString *)string {
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (id)JSONObjectFromUIColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

@end
