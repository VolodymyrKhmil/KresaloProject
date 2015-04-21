//
//  PTKTwitterAttributedText.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTwitterAttributedText.h"

@implementation PTKTwitterAttributedText {
    NSString *defaultText;
}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    
    if (self != nil) {
        defaultText = text;
        [self parseText];
    }
    
    return self;
}

- (void)parseText {
    NSRange retweetRange = [self retweetRange];
    
    if (retweetRange.length == 0) {
        _text = defaultText;
    } else {
    
        _retweet = [defaultText substringWithRange:retweetRange];
        _text = [defaultText substringFromIndex:retweetRange.length + 1];
    }
}

- (NSRange)retweetRange {
    if (![defaultText hasPrefix:@"RT @"]) {
        return NSMakeRange(0, 0);
    }
    
    NSInteger retweetLastIndex = [defaultText rangeOfString:@":"].location;
    return NSMakeRange(0, retweetLastIndex);
}

@end
