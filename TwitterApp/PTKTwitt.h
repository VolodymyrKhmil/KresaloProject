//
//  PTKTwitt.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/19/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface PTKTwitt : JSONModel <NSCopying>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *id;

@end
