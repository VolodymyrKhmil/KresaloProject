//
//  PTKTwitt.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/19/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTwitt.h"

@implementation PTKTwitt

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    
    return self.id.integerValue == [(PTKTwitt *)object id].integerValue;
}


- (NSURL *)iconURL {
    return self.user.profile_image_url;
}

@end
