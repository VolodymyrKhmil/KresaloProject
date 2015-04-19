//
//  TwitterManager.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/17/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTKTwitterManagerDelegate.h"

#define PTKController

@interface PTKTwitterManager : NSObject

@property (nonatomic, weak) id<PTKTwitterManagerDelegate> delegate;


#pragma mark authorization methods
- (void)authorizeWithCallback:(void (^)(BOOL success, NSError *error))callback;


#pragma mark data based methods
@property (nonatomic, readonly) NSInteger count;

- (void)updateTwittsWithCallback:(void (^)(BOOL success, NSError *error))callback;

- (id)twittAtIndex:(NSInteger)index;


#pragma mark singleton methods
+ (PTKTwitterManager *)sharedManager;

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedManager")));

- (instancetype)init __attribute__((unavailable("init not available, call sharedManager")));

+ (instancetype)new __attribute__((unavailable("new not available, call sharedManager")));

@end
