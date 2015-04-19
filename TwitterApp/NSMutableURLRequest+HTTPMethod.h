//
//  fd.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PTKHTTPMethod) {
    PTKHTTPMethodPost,
    PTKHTTPMethodGet,
    PTKHTTPMethodPut
};

@interface NSMutableURLRequest (HTTPMethod)

- (void)setPTKHTTPMethod:(PTKHTTPMethod)httpMethod;

@end
