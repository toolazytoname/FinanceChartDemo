//
//  PieChartView.m
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-12.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import "PieChartView.h"
#import "ColorTool.h"
#import "NumberJumpTextLayer.h"
#import "NSArray+Safe.h"

@interface PieChartView()
@property(nonatomic, retain)CAShapeLayer* shapeLayer;
@property(nonatomic, retain)CAShapeLayer* fillLayer;
@property(nonatomic, assign)CGFloat labelcount;
@property (nonatomic, strong) NSMutableArray *animationLayers;

@end

@implementation PieChartView

-(NSMutableArray *)animationLayers
{
    if (!_animationLayers) {
        _animationLayers = [[NSMutableArray alloc] init];
    }
    return _animationLayers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)strokeChartWithstrokeColors:(NSArray *)strokeColorsArray lineWidth:(CGFloat)lineWidth endAngles:(NSArray *)endAnglesArray labelCountText:(CGFloat)labelcount
{
    [self clearAllSubElements];
    
    [self setNeedsDisplay];
    for (int i = 0; i < strokeColorsArray.count; i++) {
        CGColorRef strokeColor = [[strokeColorsArray objectAtIndex:i] CGColor];
        CGFloat endAngle = [[endAnglesArray objectAtIndex:i] floatValue];
        CAShapeLayer *processLayer = [self chartLineWithfillColor:[[UIColor clearColor] CGColor] strokeColor:strokeColor lineWidth:lineWidth startAngle:M_PI_2 endAngle:M_PI_2+ M_PI*2*endAngle];
        [self addsubLayer:processLayer animated:YES];
    }
    [self addLabel:labelcount];
}
/**
 *  增加动画
 *
 *  @param layer    当前layer
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
- (void)startAnimation
{
    for (CALayer  *layer in self.animationLayers) {
        if ([layer isKindOfClass:[NumberJumpTextLayer class]]) {
            NumberJumpTextLayer *numberLayer = (NumberJumpTextLayer *)layer;
            [numberLayer jumpNumberWithDuration:2 fromNumber:0 toNumber:self.labelcount * 100];
        }
        else
        {
            [self drawLineAnimation:layer];
        }
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

-(CAShapeLayer *)chartLineWithfillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor lineWidth:(CGFloat)lineWidth startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.frame = self.bounds;
    chartLine.lineWidth = lineWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))  radius:self.frame.size.width/2 - lineWidth/2-3  startAngle:startAngle endAngle:endAngle clockwise:YES];

    chartLine.strokeColor = strokeColor;
    chartLine.fillColor = fillColor;
    chartLine.path = path.CGPath;

    return chartLine;
}
/**
 *  增加中间的label
 *
 *  @param labelcount label text
 */
-(void)addLabel:(CGFloat)labelcount
{
    self.labelcount = labelcount;
    
    NumberJumpTextLayer *textLayer = [[NumberJumpTextLayer alloc] init];
    textLayer.foregroundColor = [[ColorTool colorWithRGB:@"#0b7dd5"] CGColor];
    textLayer.fontSize = 12;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.string = @"0\%";
    textLayer.frame = CGRectMake(CGRectGetMidX(self.bounds) - 52/2, CGRectGetMidX(self.bounds) - 12/2, 52, 12);
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:textLayer];
    [textLayer jumpNumberWithDuration:2 fromNumber:0 toNumber:labelcount * 100];
    [self.animationLayers addObject:textLayer];

}
/**
 *  绘制背景圆
 *
 *  @param rect
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Draw the background of the circle.
    CGContextSetLineWidth(context, rect.size.width/2);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    rect.size.width/2/2,
                    0,
                    2*M_PI,
                    0);
    
    UIColor* color = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextStrokePath(context);
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
