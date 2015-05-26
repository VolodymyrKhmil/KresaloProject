//
//  NSDate+ToString.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 5/24/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ToString)

+ (NSDate *)dateWithString:(NSString *)string;
- (NSString *)stringValue;

@end
