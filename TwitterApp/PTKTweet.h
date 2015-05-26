//
//  PTKTweet.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/19/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "PTKEntities.h"
#import "PTKUser.h"

@interface PTKTweet : JSONModel <NSCopying>

@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) PTKEntities *entities;
@property (nonatomic, strong) PTKUser *user;


#pragma mark self generated properties
@property (nonatomic, strong) NSURL<Optional> *webPageURL;
@property (nonatomic, strong) NSURL<Optional> *twitterAppURL;


#pragma mark deep data getting properties
@property (nonatomic, readonly) NSURL *iconURL;

@end
