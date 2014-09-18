//
//  ColorTool.m
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-3-20.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import "ColorTool.h"

@implementation ColorTool
+ (UIColor *)colorWithRGB:(NSString *)hexColor
{
    NSAssert(7 == hexColor.length, @"Hex color format error!");
    
    unsigned color = 0;
    NSScanner *hexValueScanner = [NSScanner scannerWithString:[hexColor substringFromIndex:1]];
    [hexValueScanner scanHexInt:&color];
    
    int blue  =  color        & 0xFF;
    int green = (color >> 8)  & 0xFF;
    int red   = (color >> 16) & 0xFF;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}
@end
