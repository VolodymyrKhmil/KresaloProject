//
//  PTKTwitterAttributedText.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTwitterAttributedText.h"
#import "PTKHashTag.h"
#import "PTKURL.h"

@interface PTKTwitterAttributedText ()

@property (nonatomic, strong) PTKTweet *tweet;

@end


@implementation PTKTwitterAttributedText

//- (instancetype)initWithText:(NSString *)text {
//    self = [super init];
//    
//    if (self != nil) {
//        defaultText = text;
//        [self parseText];
//    }
//    
//    return self;
//}
//
//- (void)parseText {
//    NSRange retweetRange = [self retweetRange];
//    
//    if (retweetRange.length == 0) {
//        _text = defaultText;
//    } else {
//    
//        _retweet = [defaultText substringWithRange:retweetRange];
//        _text = [defaultText substringFromIndex:retweetRange.length + 1];
//    }
//}
//
//- (NSRange)retweetRange {
//    if (![defaultText hasPrefix:@"RT @"]) {
//        return NSMakeRange(0, 0);
//    }
//    
//    NSInteger retweetLastIndex = [defaultText rangeOfString:@":"].location;
//    return NSMakeRange(0, retweetLastIndex);
//}

- (instancetype)initWithTweet:(id)tweet {
    self = [super init];
    
    if (self != nil) {
        self.tweet = tweet;
        _text = [[NSAttributedString alloc] initWithString:self.tweet.text];
        [self redrawHashTags];
        [self redrawURLs];
    }
    
    return self;
}

- (void)redrawHashTags {
    NSArray *hashTags = self.tweet.entities.hashtags;
    
    if (hashTags != nil) {
        NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithAttributedString:_text];
        
        for (PTKHashTag *hashTag in hashTags) {
            NSUInteger position = [(NSNumber *)hashTag.indices.firstObject integerValue];
            NSUInteger length = [(NSNumber *)hashTag.indices.lastObject integerValue] - position;
            NSRange range = NSMakeRange(position, length);
            
            [mutableText addAttribute:NSForegroundColorAttributeName
                                value:self.tweet.user.profile_link_color
                                range:range];
        }
        
        _text = mutableText;
    }
}


- (void)redrawURLs {
    NSArray *urls = self.tweet.entities.urls;
    
    if (urls != nil) {
        NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithAttributedString:_text];
        
        for (PTKURL *url in urls) {
            NSUInteger position = [(NSNumber *)url.indices.firstObject integerValue];
            NSUInteger length = [(NSNumber *)url.indices.lastObject integerValue] - position;
            NSRange range = NSMakeRange(position, length);
            
            [mutableText addAttribute:NSForegroundColorAttributeName
                                value:self.tweet.user.profile_link_color
                                range:range];
        }
        
        _text = mutableText;
    }
}


@end
