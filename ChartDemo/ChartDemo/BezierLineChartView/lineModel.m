//
//  lineModel.m
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-10.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import "lineModel.h"

@implementation lineModel
- (instancetype)init {
    if((self = [super init])) {
    }
    return self;
}




- (instancetype)initWith:(NSArray *)valuePoints lineColor:(UIColor *)lineColor pointColor:(UIColor *)pointColor width:(float)lineWidth title:(NSString *)title titleFrame:(CGRect)titleFrame
{
    if((self = [self init])) {
        self.valuePoints = valuePoints;
        self.lineColor = lineColor;
        self.pointColor = pointColor;
        self.lineWidth = lineWidth;
        self.title = title;
        self.titleFrame = titleFrame;
    }
    return self;
}

@end
