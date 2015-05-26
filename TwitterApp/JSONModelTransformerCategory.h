//
//  JSONModelTransformerCategory.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/22/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JSONModel.h"

@interface JSONValueTransformer(UIColor)

- (UIColor *)UIColorFromNSString:(NSString *)string;
- (id)JSONObjectFromUIColor:(UIColor *)color;

- (NSDate *)NSDateFromNSString:(NSString *)string;
- (id)JSONObjectFromNSDate:(NSDate *)date;

@end
