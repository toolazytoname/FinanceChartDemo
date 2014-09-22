//
//  PieChartView.h
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-12.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView
/**
 *  按照传入的数组顺序绘制圆环
 *
 *  @param strokeColorsArray 颜色数组，依次增加layer，注意顺序，防止遮挡
 *  @param lineWidth         线宽
 *  @param endAnglesArray    结束角度数组，如果90%，则传入@0.25。依次增加layer，注意顺序，防止遮挡
 *  @param labelcount        圆圈中间显示的标签
 */
-(void)strokeChartWithstrokeColors:(NSArray *)strokeColorsArray lineWidth:(CGFloat)lineWidth endAngles:(NSArray *)endAnglesArray labelCountText:(CGFloat)labelcount;

/**
 *  开始动画
 *
 */
- (void)startAnimation;

/**
 *  清除当前页面的子layer
 *
 */
- (void)clearAllSubElements;


@end
