//
//  NSDictionary+Safe.m
//  NewsHD
//
//  Created by sgl on 13-1-11.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)
- (id)objectForKeyNotNull:(id)key
{
    id r = [self objectForKey:key];
    if (r == [NSNull null]) {
        return nil;
    }
    return r;
}

@end
