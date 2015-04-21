//
//  PTURLDataCacher.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKURLDataCacher : NSObject

+ (instancetype)defaultCacher;

- (NSData *)getDataForURL:(NSURL *)url elseTryLoadAsyncWithCallback:(void (^)(BOOL success, NSData *data))callback;

@end
