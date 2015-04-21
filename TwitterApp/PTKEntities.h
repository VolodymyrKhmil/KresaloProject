//
//  PTKEntities.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/20/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "PTKMedia.h"

@interface PTKEntities : JSONModel <NSCopying>

@property (nonatomic, strong) NSArray<PTKMedia, Optional> *media;

@end
