//
//  BezierLineChartView.h
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-15.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lineModel.h"

@interface BezierLineChartView : UIView



/**
 *  标题
 */
@property (nonatomic, strong) NSString  *maintitle;
/**
 *  标题位置
 */
@property (nonatomic, assign) CGRect  maintitleRect;


/**
 *  原点坐标
 */
@property (nonatomic, assign) CGPoint  orignalPoint;

/**
 *  x轴的长度
 */
@property (nonatomic,assign) CGFloat xAxisLength;
/**
 *  y轴的长度
 */
@property (nonatomic,assign) CGFloat yAxisLength;

/**
 *  X轴值，数组
 */
@property (nonatomic, strong) NSArray *xAxisValues;
/**
 *  Y轴值，数组
 */
@property (nonatomic, strong) NSArray *yAxisValues;

/**
 *  由lineModel构成的线数组,
 */
@property (nonatomic, strong) NSMutableArray *lineArray;

/**
 *  绘制
 */
-(void)draw;

/**
 *  清除线对象
 *
 */
-(void)clearLines;

/**
 *  增加线对象
 *
 *  @param newLineModel 线对象
 */
- (void)addLine:(lineModel *)newLineModel;

/**
 *  开始动画
 *
 */
- (void)startAnimation;


/**
 *  清除当前View 的子layer
 *
 */
-(void)clearAllSubElements;

@end
