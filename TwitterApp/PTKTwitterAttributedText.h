//
//  PTKTwitterAttributedText.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKTwitterAttributedText : NSObject

@property (nonatomic, readonly) NSString *retweet;
@property (nonatomic, retain) NSString *text;

- (instancetype)initWithText:(NSString *)text;

@end
