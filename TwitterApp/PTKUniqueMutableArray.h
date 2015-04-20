//
//  PTKUniqueArray.h
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/20/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKUniqueMutableArray : NSMutableArray

- (void)addToFrontObject:(id)anObject;
- (void)addToFrontObjectsFromArray:(NSArray *)otherArray;

@end
