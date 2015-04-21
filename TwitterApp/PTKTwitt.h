//
//  PTKTwitt.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/19/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "PTKEntities.h"
#import "PTKUser.h"

@interface PTKTwitt : JSONModel <NSCopying>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) PTKEntities *entities;
@property (nonatomic, strong) PTKUser *user;



#pragma mark own methods
@property (nonatomic, readonly) NSURL *iconURL;

@end
