//
//  PTKUser.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface PTKUser : JSONModel<NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSURL *profile_image_url;
@property (nonatomic, strong) UIColor *profile_link_color;
@property (nonatomic, strong) UIColor *profile_text_color;

@end
