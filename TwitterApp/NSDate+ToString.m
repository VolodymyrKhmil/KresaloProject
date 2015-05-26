//
//  NSDate+ToString.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 5/24/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "NSDate+ToString.h"

static NSString * const PTKDateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";

@implementation NSDate (ToString)

+ (NSDate *)dateWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:PTKDateFormat];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

- (NSString *)stringValue {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:PTKDateFormat];
    NSString *string = [dateFormatter stringFromDate:self];
    return string;
}

@end
