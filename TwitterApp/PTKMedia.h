//
//  PTKMedia.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/20/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol PTKMedia

@end



@interface PTKMedia : JSONModel<NSCopying>

@property (nonatomic, strong) NSURL *media_url;

@end
