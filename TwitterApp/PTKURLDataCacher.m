//
//  PTURLDataCacher.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKURLDataCacher.h"


@implementation PTKURLDataCacher {
    NSCache *cache;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        self->cache = [NSCache new];
    }
    return self;
}

+ (instancetype)defaultCacher {
    static PTKURLDataCacher *defaultCacher;
    
    static dispatch_once_t PTKDefaultURLDataCacherDispatchToken;
    
    dispatch_once(&PTKDefaultURLDataCacherDispatchToken, ^{
        defaultCacher = [PTKURLDataCacher new];
    });
    
    return defaultCacher;
}


- (NSData *)getDataForURL:(NSURL *)url elseTryLoadAsyncWithCallback:(void (^)(BOOL, NSData *))callback {
    NSData *data = [cache objectForKey:url.absoluteString];
    
    if (data == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *newData = [NSData dataWithContentsOfURL:url];
            if (newData != nil) {
                @synchronized(cache) {
                    [cache setObject:newData forKey:url.absoluteString];
                }
            }
            callback(newData != nil, newData);
        });
    }
    return data;
}

@end
