//
//  fd.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/18/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "NSMutableURLRequest+HTTPMethod.h"

@implementation NSMutableURLRequest (HTTPMethod)

- (void)setPTKHTTPMethod:(PTKHTTPMethod)httpMethod {
    NSString *httpMethodString;
    switch (httpMethod) {
        case PTKHTTPMethodPost:
            httpMethodString = @"POST";
            break;
        case PTKHTTPMethodGet:
            httpMethodString = @"GET";
            break;
        case PTKHTTPMethodPut:
            httpMethodString = @"PUT";
            break;
        default:
            break;
    }
    
    if (httpMethodString != nil) {
        [self setHTTPMethod: httpMethodString];
    }
}

@end
