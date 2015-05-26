//
//  PTKUniqueArray.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/20/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKUniqueMutableArray.h"

@implementation PTKUniqueMutableArray {
    NSMutableArray *_array;
}


#pragma mark overloaded methods
- (id)init {
    self = [super init];
    if (self != nil) {
        self->_array = [NSMutableArray new];
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
    return [self init];
}

- (void)addObject:(id)anObject {
    if ([self indexOfObject:anObject] == NSNotFound) {
        [self->_array addObject:anObject];
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    for (id anObject in otherArray) {
        [self addObject:anObject];
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    if ([self indexOfObject:anObject] == NSNotFound) {
        [self->_array insertObject:anObject atIndex:index];
    }
}

- (NSUInteger)indexOfObject:(id)anObject {
    for (NSUInteger i = 0; i < self.count; ++i) {
        NSObject *currentObject = [self objectAtIndex:i];
        if ([currentObject isEqual:anObject]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSUInteger)count {
    return self->_array.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self->_array objectAtIndex:index];
}

#pragma mark new methods
- (void)addToFrontObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)addToFrontObjectsFromArray:(NSArray *)otherArray {
    for (id anObject in otherArray.reverseObjectEnumerator) {
        [self addToFrontObject:anObject];
    }
}

@end
