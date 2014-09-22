//
//  BezierLineChartView.m
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-15.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import "BezierLineChartView.h"
#import "NSArray+Safe.h"
#import "ColorTool.h"

@interface BezierLineChartView()
/**
 *  坐标轴旁边的字体
 */
@property (nonatomic, strong) NSString* fontName;
/**
 *  Y坐标轴旁边的字体大小
 */
@property (nonatomic, assign) CGFloat yAxisFontSize;
/**
 *  Y轴坐标轴，线的宽度
 */
@property (nonatomic, assign) CGFloat yAxisLineWidth;
/**
 *  Y轴坐标轴，颜色
 */
@property (nonatomic, strong) UIColor *yAxisLineColor;
/**
 *  拿y轴的长度值 除以 数值的变化幅度 得出的一个单位
 */
@property (nonatomic, assign) CGFloat yIntervalValue;
/**
 *  the yAxis label text should be formatted with
 */
@property (nonatomic, strong) NSString*  yFormatterString;

/**
 *  Y轴上标签的x坐标
 */
@property (nonatomic, assign) CGFloat yAxisLabelFrameX;


@property (nonatomic, assign) CGFloat xAxisFontSize;
@property (nonatomic, assign) CGFloat xAxisLineWidth;
@property (nonatomic, strong) UIColor *xAxisLineColor;
@property (nonatomic, strong) NSString* xFormatterString; // the yAxis label text should be formatted with
@property (nonatomic, assign) CGFloat xIntervalValue;
@property (nonatomic, assign) CGFloat xAxisLabelFrameY;

@property (nonatomic, strong) NSMutableArray *animationLayers;
@end




@implementation BezierLineChartView

-(NSMutableArray *)animationLayers
{
    if (!_animationLayers) {
        _animationLayers = [[NSMutableArray alloc] init];
    }
    return _animationLayers;
}

- (instancetype)init {
    if((self = [super init])) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
/**
 *  默认设置
 */
-(void)commonInit{
    self.fontName=@"Helvetica";
    self.yAxisFontSize = 7.5;
    self.yAxisLineWidth = 0.2;
    self.yAxisLineColor = [UIColor blackColor];
    self.yAxisLabelFrameX = 28.0;
    
    self.xAxisLineColor = [UIColor greenColor];
    
    if (self.yAxisValues.count > 0) {
        self.yIntervalValue = self.yAxisLength / ([self.yAxisValues.lastObject floatValue] - [self.yAxisValues.firstObject floatValue]);
    }
    
    if (self.xAxisValues.count > 0) {
//        self.xIntervalValue = self.xAxisLength / ([self.xAxisValues.lastObject floatValue] - [self.xAxisValues.firstObject floatValue]);
        self.xIntervalValue = self.xAxisLength / 6;
    }
    self.yFormatterString = @"%.2f";
    self.xFormatterString = @"%.2f";
    self.xAxisFontSize = 7.5;
    
    self.xAxisLabelFrameY = 160.0;
    
    
    self.maintitle = @"历史预测对比曲线";
    self.maintitleRect = CGRectMake(28.0, 15, 100, 11);
    self.orignalPoint = CGPointMake(48.0f, 135.0f);
    self.xAxisLength = 249.0f;
    self.yAxisLength = 85.0f;
}

-(void)clearLines
{
    [self.lineArray removeAllObjects];
}

- (void)addLine:(lineModel *)newLineModel
{
    if(nil == newLineModel ) {
        return;
    }
    
    if (newLineModel.valuePoints.count ==0) {
        return;
    }
    if(self.lineArray == nil){
        _lineArray = [NSMutableArray array];
    }
    [self.lineArray addObject:newLineModel];

}

-(void)draw
{
    [self clearAllSubElements];
    [self commonInit];
    [self drawYAxis];
    [self drawXAxis];
    [self drawFolderLine];
    [self drawCircleOnFolderLine];
    [self drawTitle];
    [self drawShortTopLine];
    [self drawCircleOnShortTopLine];
    
}
- (void)startAnimation
{
    for (CAShapeLayer  *layer in self.animationLayers) {
        [self drawLineAnimation:layer];
    }
}
/**
 *  画Y轴
 */
-(void)drawYAxis
{
    CAShapeLayer *yAxisLayer = [self yChartLineWithfillColor:[[UIColor clearColor] CGColor] strokeColor:[[ColorTool colorWithRGB:@"#f0f0f0"] CGColor] lineWidth:0.5];
    [self addsubLayer:yAxisLayer animated:NO];
    for (int i = 0; i < self.yAxisValues.count ; i++) {
        CGFloat originalYValue = [self getYCalulatorByValue:[[self.yAxisValues objectAtIndex:i] floatValue]];
        NSNumber* yAxisVlue = [self.yAxisValues objectAtIndex:i];
        NSString* numberString = [NSString stringWithFormat:self.yFormatterString, yAxisVlue.floatValue];
        UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.yAxisLabelFrameX, originalYValue- self.yAxisFontSize/2, 20, 6)];
        yAxisLabel.text = numberString;
        yAxisLabel.font = [UIFont systemFontOfSize:self.yAxisFontSize];
        yAxisLabel.textColor = [ColorTool colorWithRGB:@"#999999"];
        [self addSubview:yAxisLabel];
    }
}
/**
 *  画X轴
 */
-(void)drawXAxis
{
    CAShapeLayer *xAxisLayer = [self xChartLineWithfillColor:[[UIColor clearColor] CGColor] strokeColor:[[ColorTool colorWithRGB:@"#f0f0f0"] CGColor] lineWidth:0.5];
    [self addsubLayer:xAxisLayer animated:NO];
    for (int i = 0; i < self.xAxisValues.count ; i++) {
        CGFloat originalXValue = [self getXCalulatorByValue:[[self.xAxisValues objectAtIndex:i] floatValue] index:i];
        NSNumber* xAxisVlue = [self.xAxisValues objectAtIndex:i];
        NSString* numberString = [NSString stringWithFormat:self.xFormatterString, xAxisVlue.floatValue];
        UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(originalXValue - self.xAxisFontSize/2,self.xAxisLabelFrameY , 20, 6)];
        yAxisLabel.text = numberString;
        yAxisLabel.font = [UIFont systemFontOfSize:self.xAxisFontSize];
        yAxisLabel.textColor = [ColorTool colorWithRGB:@"#999999"];
        [self addSubview:yAxisLabel];
    }
}
/**
 *  画折线
 */
-(void)drawFolderLine
{
    for (int i = 0; i < self.lineArray.count; i++) {
        lineModel *lineModel = [self.lineArray safeObjectAtIndex:i];
        CAShapeLayer *foldLineLayer = [self foldLineWithfillColor:[[UIColor clearColor] CGColor]  strokeColor:[lineModel.lineColor CGColor] lineWidth:1 pointArray:lineModel.valuePoints];
        [self addsubLayer:foldLineLayer animated:YES];
    }
}
/**
 *  画折线上面的圆圈
 */
-(void)drawCircleOnFolderLine
{
    for (int i = 0; i < self.lineArray.count; i++) {
        lineModel *lineModel = [self.lineArray safeObjectAtIndex:i];
        for (int pointIndex = 1; pointIndex < lineModel.valuePoints.count; pointIndex++) {
            CGPoint currentValuePoint =  [[lineModel.valuePoints safeObjectAtIndex:pointIndex] CGPointValue];
            CGPoint currentPoint = CGPointMake([self getXCalulatorByValue:currentValuePoint.x index:pointIndex], [self getYCalulatorByValue:currentValuePoint.y]);
            CAShapeLayer *circleLayer = [self circleWithfillColor:[[UIColor whiteColor] CGColor]  strokeColor:[lineModel.pointColor CGColor] lineWidth:1.0 point:currentPoint];
            [self addsubLayer:circleLayer animated:YES];
        }
    }
}

/**
 *  画上方的标题
 */
-(void)drawTitle
{
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:self.maintitleRect];
    mainTitleLabel.font = [UIFont systemFontOfSize:11.5];
    mainTitleLabel.textColor = [ColorTool colorWithRGB:@"#666666"];
    mainTitleLabel.text = self.maintitle;
    [self addSubview:mainTitleLabel];
    
    for (int i = 0; i < self.lineArray.count; i++) {
        lineModel *lineModel = [self.lineArray safeObjectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:lineModel.titleFrame];
        label.text = lineModel.title;
        label.textColor = lineModel.lineColor;
        label.font = [UIFont systemFontOfSize:11.5];
        [self addSubview:label];
    }
}

/**
 *  画折线上方的线
 */
-(void)drawShortTopLine
{
    NSMutableArray *firstPointArray = [NSMutableArray array];
    [firstPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(166.0 - 20.0f, 20.5)]];
    [firstPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(166.0 - 3.0f, 20.5)]];
    lineModel *firstPlot = [[lineModel alloc] initWith:firstPointArray lineColor:[ColorTool colorWithRGB:@"#0b7dd5"] pointColor:[ColorTool colorWithRGB:@"#0b7dd5"] width:1 title:@"预测股价" titleFrame:CGRectMake(166.0f,15.0f, 50.0f, 11.0f)];
    
    
    NSMutableArray *secondPointArray = [NSMutableArray array];
    [secondPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(250.0f -20.0f, 20.5)]];
    [secondPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(250.0f -3.0f, 20.5)]];
    lineModel *secondPlot = [[lineModel alloc] initWith:secondPointArray lineColor:[ColorTool colorWithRGB:@"#c9c9c9"] pointColor:[ColorTool colorWithRGB:@"#c9c9c9"] width:1 title:@"现实股价" titleFrame:CGRectMake(166.0f,15.0f, 50.0f, 11.0f)];
    
    
    NSArray *lineArray = [NSArray arrayWithObjects:firstPlot,secondPlot, nil];
    for (int i = 0; i < lineArray.count; i++) {
        lineModel *lineModel = [lineArray safeObjectAtIndex:i];
        CAShapeLayer *foldLineLayer = [self shortFoldLineWithfillColor:[[UIColor clearColor] CGColor]  strokeColor:[lineModel.lineColor CGColor] lineWidth:1.0 pointArray:lineModel.valuePoints];
        [self addsubLayer:foldLineLayer animated:YES];
    }
}
/**
 *  画折线上面的圆
 */
-(void)drawCircleOnShortTopLine
{
    NSMutableArray *firstPointArray = [NSMutableArray array];
    [firstPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(166.0 - 11.5f, 20.5)]];
    lineModel *firstPlot = [[lineModel alloc] initWith:firstPointArray lineColor:[ColorTool colorWithRGB:@"#0b7dd5"] pointColor:[ColorTool colorWithRGB:@"#0b7dd5"] width:1 title:@"预测股价" titleFrame:CGRectMake(166.0f,15.0f, 50.0f, 11.0f)];
    
    
    NSMutableArray *secondPointArray = [NSMutableArray array];
    [secondPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(250.0f -11.5f, 20.5)]];
    lineModel *secondPlot = [[lineModel alloc] initWith:secondPointArray lineColor:[ColorTool colorWithRGB:@"#c9c9c9"] pointColor:[ColorTool colorWithRGB:@"#c9c9c9"] width:1 title:@"现实股价" titleFrame:CGRectMake(166.0f,15.0f, 50.0f, 11.0f)];
    
    
    NSArray *lineArray = [NSArray arrayWithObjects:firstPlot,secondPlot, nil];
    for (int i = 0; i < lineArray.count; i++) {
        lineModel *lineModel = [lineArray safeObjectAtIndex:i];
        for (int pointIndex = 0; pointIndex < lineModel.valuePoints.count; pointIndex++) {
            CGPoint currentPoint =  [[lineModel.valuePoints safeObjectAtIndex:pointIndex] CGPointValue];
            CAShapeLayer *circleLayer = [self circleWithfillColor:[[UIColor whiteColor] CGColor]  strokeColor:[lineModel.pointColor CGColor] lineWidth:1.0 point:currentPoint];
            [self addsubLayer:circleLayer animated:YES];
        }
    }
}


/**
 *  生成Y轴线对象
 *
 *  @param fillColor   颜色
 *  @param strokeColor 颜色
 *  @param lineWidth   线宽度
 *
 *  @return Y轴的layer
 */
-(CAShapeLayer *)yChartLineWithfillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
//    chartLine.frame = self.bounds;
    chartLine.lineWidth = lineWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.orignalPoint];
    [path addLineToPoint:CGPointMake(self.orignalPoint.x, self.orignalPoint.y - self.yAxisLength)];
    
    chartLine.strokeColor = strokeColor;
    chartLine.fillColor = fillColor;
    chartLine.path = path.CGPath;
    
    return chartLine;
}

/**
 *  生成x轴线对象
 *
 *  @param fillColor   颜色
 *  @param strokeColor 颜色
 *  @param lineWidth   线宽度
 *
 *  @return x轴layer
 */
-(CAShapeLayer *)xChartLineWithfillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.frame = self.bounds;
    chartLine.lineWidth = lineWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.orignalPoint];
    [path addLineToPoint:CGPointMake(self.orignalPoint.x + self.xAxisLength, self.orignalPoint.y)];
    
    chartLine.strokeColor = strokeColor;
    chartLine.fillColor = fillColor;
    chartLine.path = path.CGPath;
    
    return chartLine;
}

/**
 *  生成折线对象
 *
 *  @param fillColor   颜色
 *  @param strokeColor 颜色
 *  @param lineWidth   线宽度
 *  @param pointArray  点集合
 *
 *  @return 折线layer
 */
-(CAShapeLayer *)foldLineWithfillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth pointArray:(NSArray *)pointArray
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.frame = self.bounds;
    chartLine.lineWidth = lineWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int pointIndex = 0; pointIndex < pointArray.count - 1; pointIndex++) {
        CGPoint currentValuePoint =  [[pointArray safeObjectAtIndex:pointIndex] CGPointValue];
        CGPoint nextValuePoint =  [[pointArray safeObjectAtIndex:pointIndex + 1] CGPointValue];
        
        CGPoint currentPoint = CGPointMake([self getXCalulatorByValue:currentValuePoint.x index:pointIndex], [self getYCalulatorByValue:currentValuePoint.y]);
        CGPoint nextPoint = CGPointMake([self getXCalulatorByValue:nextValuePoint.x index:pointIndex+1], [self getYCalulatorByValue:nextValuePoint.y]);
        
        [path moveToPoint:currentPoint];
        [path addLineToPoint:nextPoint];
    }
    chartLine.strokeColor = strokeColor;
    chartLine.fillColor = fillColor;
    chartLine.path = path.CGPath;
    
    return chartLine;
}

/**
 *  折线上方的短直线
 *
 *  @param fillColor   颜色
 *  @param strokeColor 颜色
 *  @param lineWidth   线宽
 *  @param pointArray  点集合
 *
 *  @return 短直线的layer
 */
-(CAShapeLayer *)shortFoldLineWithfillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth pointArray:(NSArray *)pointArray
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.frame = self.bounds;
    chartLine.lineWidth = lineWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int pointIndex = 0; pointIndex < pointArray.count - 1; pointIndex++) {
        CGPoint currentPoint =  [[pointArray safeObjectAtIndex:pointIndex] CGPointValue];
        CGPoint nextPoint =  [[pointArray safeObjectAtIndex:pointIndex + 1] CGPointValue];
        [path moveToPoint:currentPoint];
        [path addLineToPoint:nextPoint];
    }
    chartLine.strokeColor = strokeColor;
    chartLine.fillColor = fillColor;
    chartLine.path = path.CGPath;
    
    return chartLine;
}

/**
 *  圆
 *
 *  @param fillColor   颜色
 *  @param strokeColor 颜色
 *  @param lineWidth   线宽度
 *  @param point  圆的圆点
 *
 *  @return 圆 的layer
 */
-(CAShapeLayer *)circleWithfillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth point:(CGPoint)point
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.frame = self.bounds;
    chartLine.lineWidth = lineWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:point  radius:2  startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    chartLine.strokeColor = strokeColor;
    chartLine.fillColor = fillColor;
    chartLine.path = path.CGPath;
    
    return chartLine;
}


/**
 *  增加layer 到 目标layer 上
 *
 *  @param layer    待 add的layer
 *  @param animated 是否有动画
 */
-(void)addsubLayer:(CAShapeLayer *)layer animated:(BOOL)animated
{
    [self.layer addSublayer: layer];
    if (animated) {
        [self drawLineAnimation:layer];
        [self.animationLayers addObject:layer];
    }
}

/**
 *  增加动画
 *
 *  @return 当前layer
 */
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}


/**
 *  原点坐标 + （当前数值 - y轴初始值）*比例
 *
 *  @param yValue 当前数值
 *
 *  @return Y坐标
 */
-(CGFloat)getYCalulatorByValue:(CGFloat)yValue
{
    CGFloat YCalculatorValue = self.orignalPoint.y - (yValue - [[self.yAxisValues firstObject] floatValue])* self.yIntervalValue;
    return YCalculatorValue;
}

-(CGFloat)getXCalulatorByValue:(CGFloat)XValue index:(int)index
{
//    CGFloat xCalculatorValue = self.orignalPoint.x + (XValue - [[self.xAxisValues firstObject] floatValue])* self.xIntervalValue;
    CGFloat xCalculatorValue = self.orignalPoint.x + index * self.xIntervalValue;
    return xCalculatorValue;
}

-(void)clearAllSubElements
{
    [self clearAllSubLayers];
}

-(void)clearAllSubLayers
{
    NSArray *subLayers = [self.layer.sublayers copy];
    for (CALayer *subLayer in subLayers) {
        [subLayer removeFromSuperlayer];
    }
}

@end
