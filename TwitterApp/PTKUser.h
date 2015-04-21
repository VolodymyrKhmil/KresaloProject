//
//  PTKUser.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface PTKUser : JSONModel<NSCopying>

@property (nonatomic, strong) NSURL *profile_image_url;

@end
