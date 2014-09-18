//
//  lineModel.h
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-10.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lineModel : NSObject
@property (nonatomic, strong) NSArray *valuePoints;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, strong) UIColor* lineColor;
@property (nonatomic, strong) UIColor* pointColor;
@property (nonatomic, assign) float lineWidth;

- (instancetype)initWith:(NSArray *)valuePoints lineColor:(UIColor *)lineColor pointColor:(UIColor *)pointColor width:(float)lineWidth title:(NSString *)title titleFrame:(CGRect)titleFrame;
@end
