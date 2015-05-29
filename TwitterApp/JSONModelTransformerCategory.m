//
//  JSONModelTransformerCategory.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/22/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "JSONModelTransformerCategory.h"
#import "NSDate+ToString.h"
#import "UIColor+ToString.h"

static NSString * const PTKTwitterDateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";

@implementation JSONValueTransformer (UIColor)
#pragma mark color transfering

- (UIColor *)UIColorFromNSString:(NSString *)string {
    return [UIColor colorWithString:string];
}

- (id)JSONObjectFromUIColor:(UIColor *)color {
    return [color stringValue];
}

#pragma mark date transfering

- (NSDate *)NSDateFromNSString:(NSString *)string {
    return [NSDate dateWithString:string];
}

- (id)JSONObjectFromNSDate:(NSDate *)date {
    
    return [date stringValue];
}

@end
