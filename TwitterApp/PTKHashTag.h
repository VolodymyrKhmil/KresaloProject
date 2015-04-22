//
//  PTKHashTag.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/22/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol PTKHashTag
@end

@interface PTKHashTag : JSONModel<NSCopying>

@property (nonatomic, strong) NSArray *indices;
@property (nonatomic, strong) NSString *text;

@end
