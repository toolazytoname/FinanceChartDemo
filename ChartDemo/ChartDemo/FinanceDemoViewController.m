//
//  FinanceDemoViewController.m
//  Rubic's Cube No StoryBoard
//
//  Created by SINA on 14-9-10.
//  Copyright (c) 2014年 weichao. All rights reserved.
//

#import "FinanceDemoViewController.h"
#import "BezierLineChartView.h"
#import "PieChartView.h"
#import "ColorTool.h"
#import "UIView-ViewFrameGeometry.h"
#import "NSDictionary+Safe.h"
#import "NSArray+Safe.h"


@interface FinanceDemoViewController ()


@property (strong, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *topRightLabel;

@property (strong, nonatomic) IBOutlet UILabel *leftPieTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *middlePieTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightPieTopLabel;

@property (strong, nonatomic) IBOutlet PieChartView *leftPieChartView;
@property (strong, nonatomic) IBOutlet PieChartView *middlePieChartView;
@property (strong, nonatomic) IBOutlet PieChartView *rightPieChartView;

@property (strong, nonatomic) IBOutlet UILabel *leftPieBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *middlePieBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightPieBottomLabel;


@property (strong, nonatomic) IBOutlet UIView *leftSplitView;
@property (strong, nonatomic) IBOutlet UIView *rightSplitView;
@property (strong, nonatomic) IBOutlet UIView *upDownSplitView;

@property (strong, nonatomic) IBOutlet BezierLineChartView *lineChartView;

@end

@implementation FinanceDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;

    [self loadWithUrl:@"http://platform.sina.com.cn/client/Forecast?app_key=4135432745&code=sz000001"];
}

-(IBAction)loadAnother:(id)sender
{
    [self loadWithUrl:@"http://platform.sina.com.cn/client/Forecast?app_key=4135432745&code=sz000002"];

}
-(IBAction)clear:(id)sender
{
    [self.leftPieChartView clearAllSubElements];
    [self.lineChartView clearAllSubElements];
}
-(IBAction)startAnimation:(id)sender
{
    [self.leftPieChartView startAnimation];
    [self.middlePieChartView startAnimation];
    [self.rightPieChartView startAnimation];
    
    [self.lineChartView startAnimation];
}

-(void)loadWithUrl:(NSString *)urlString
{    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSError *urlError;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&urlError];
    NSError *parseError;
    NSDictionary *returnDataDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&parseError];
    NSDictionary *dataDic = [[returnDataDic objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
    [self loadData:dataDic];

}

//加载数据
-(void)loadData:(NSDictionary *)dataDic
{
    NSArray *ForecastArray = [dataDic objectForKeyNotNull:@"Forecast"];
    NSDictionary *GainProbDic = [dataDic objectForKeyNotNull:@"GainProb"];
    [self addLabelSubviews:GainProbDic];
    [self addPieChart:GainProbDic];
    [self addLineChart:ForecastArray];
}

-(void)addLabelSubviews:(NSDictionary *)GainProbDic
{
    self.topLeftLabel.font = [UIFont systemFontOfSize:11.5];
    self.topLeftLabel.textColor = [ColorTool colorWithRGB:@"#666666"];
    self.topLeftLabel.text = [NSString stringWithFormat:@"%@ 胜算量化分析",[GainProbDic objectForKeyNotNull:@"frcEndDate"]];
    
    //预测
    NSString *highPriceString = [self getStringWithString:[GainProbDic objectForKeyNotNull:@"highPrice"]];

    NSString *topRightString = [NSString stringWithFormat:@"预测价: %@",highPriceString];
    NSMutableAttributedString *topRightStringAtti = [[NSMutableAttributedString alloc] initWithString:topRightString];
    [topRightStringAtti addAttribute:NSForegroundColorAttributeName value:[ColorTool colorWithRGB:@"#666666"]  range:NSMakeRange(0, 4)];
    [topRightStringAtti addAttribute:NSForegroundColorAttributeName value:[ColorTool colorWithRGB:@"#0b7dd5"]  range:NSMakeRange(4, topRightString.length - 4)];
    self.topRightLabel.font = [UIFont systemFontOfSize:11.5];
    self.topRightLabel.attributedText = topRightStringAtti;
    
    self.leftPieTopLabel.font = [UIFont systemFontOfSize:8.5];
    self.leftPieTopLabel.textColor = [ColorTool colorWithRGB:@"#a3a3a3"];
    
    NSMutableAttributedString *middlePieTopStringAtti = [[NSMutableAttributedString alloc] initWithString:@"昨收" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#a3a3a3"],NSForegroundColorAttributeName, nil]];
    [middlePieTopStringAtti appendAttributedString: [[NSAttributedString alloc] initWithString:@"[6.15]" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#0b7dd5"],NSForegroundColorAttributeName, nil]]];
    [middlePieTopStringAtti appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"预测" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#a3a3a3"],NSForegroundColorAttributeName, nil]]];
    [middlePieTopStringAtti appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"[6.25]" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#0b7dd5"],NSForegroundColorAttributeName, nil]]];
    self.middlePieTopLabel.attributedText = middlePieTopStringAtti;
    
    self.rightPieTopLabel.font = [UIFont systemFontOfSize:8.5];
    self.rightPieTopLabel.textColor = [ColorTool colorWithRGB:@"#a3a3a3"];
    
    self.leftPieBottomLabel.font = [UIFont systemFontOfSize:11.5];
    self.leftPieBottomLabel.textColor = [ColorTool colorWithRGB:@"#666666"];
    
    self.middlePieBottomLabel.font = [UIFont systemFontOfSize:11.5];
    self.middlePieBottomLabel.textColor = [ColorTool colorWithRGB:@"#666666"];
    
    self.rightPieBottomLabel.font = [UIFont systemFontOfSize:11.5];
    self.rightPieBottomLabel.textColor = [ColorTool colorWithRGB:@"#666666"];
    
    self.leftSplitView.width = 0.5;
    self.leftSplitView.backgroundColor = [ColorTool colorWithRGB:@"#f0f0f0"];
    
    self.rightSplitView.width = 0.5;
    self.rightSplitView.backgroundColor = [ColorTool colorWithRGB:@"#f0f0f0"];
    
    self.upDownSplitView.height = 0.5;
    self.upDownSplitView.backgroundColor = [ColorTool colorWithRGB:@"#f0f0f0"];
    
 

}

-(void)addPieChart:(NSDictionary *)GainProbDic
{
    //GainProb: 【上面-图形数据】
    //
    //{
    //    ·         nextClosePrice: "-",[实际收盘价]
    //    ·         frcEndDate: "2014-09-17",[预测日期]
    //    ·         highPrice: "10.333",[预测价格]
    //    ·         frcGainProb: "0.428350",[上涨概率]
    //    ·         position: "0.5",[最佳仓位]
    //    ·         frcVolatility: "0.008129"【预计涨幅】
    //              LastClosePrice: ""【昨收价】
    
    //}
    if (!GainProbDic || ![GainProbDic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"传入参数 GainProbDic数据有误");
        return;
    }
    
    //上涨概率
    NSNumber *frcGainProbFloatNumber  = [self getNumberWithString:[GainProbDic objectForKeyNotNull:@"frcGainProb"]];
    if (frcGainProbFloatNumber && frcGainProbFloatNumber.floatValue > 0) {
        NSArray *strokeColorsArray1 = [NSArray arrayWithObjects:[ColorTool colorWithRGB:@"#1067cb"], nil];
        NSArray *endAnglesArray1 = [NSArray arrayWithObjects:frcGainProbFloatNumber, nil];
        [self.leftPieChartView strokeChartWithstrokeColors:strokeColorsArray1 lineWidth:11.0 endAngles:endAnglesArray1 labelCountText:[frcGainProbFloatNumber floatValue]];
    }
    
    //预计涨幅
    NSNumber *frcVolatilityNumber =  [self getNumberWithString:[GainProbDic objectForKeyNotNull:@"frcVolatility"]];
    //昨收
    NSNumber *LastClosePriceNumber = [self getNumberWithString:[GainProbDic objectForKeyNotNull:@"LastClosePrice"]];
    //预测
    NSNumber *highPriceNumber = [self getNumberWithString:[GainProbDic objectForKeyNotNull:@"highPrice"]];
    //最优仓位
    NSNumber *positionNumber = [self getNumberWithString:[GainProbDic objectForKeyNotNull:@"position"]];
    float maxValue = MAX(LastClosePriceNumber.floatValue, highPriceNumber.floatValue);
    float minValue = MIN(LastClosePriceNumber.floatValue, highPriceNumber.floatValue);
    float amountValue = minValue/maxValue;
    
    if(frcVolatilityNumber && frcVolatilityNumber.floatValue > 0)
    {
        NSArray *strokeColorsArray2 = [NSArray arrayWithObjects:[ColorTool colorWithRGB:@"#932b67"],[ColorTool colorWithRGB:@"#dd64aa"], nil];
        NSArray *endAnglesArray2 = [NSArray arrayWithObjects:@1,[NSNumber numberWithFloat:amountValue], nil];
        [self.middlePieChartView strokeChartWithstrokeColors:strokeColorsArray2 lineWidth:11.0 endAngles:endAnglesArray2 labelCountText:[frcVolatilityNumber floatValue]];
    }
    
    if(positionNumber && positionNumber.floatValue > 0 )
    {
        NSArray *strokeColorsArray3 = [NSArray arrayWithObjects:[ColorTool colorWithRGB:@"#ff9000"],nil];
        NSArray *endAnglesArray3 = [NSArray arrayWithObjects:positionNumber, nil];
        [self.rightPieChartView strokeChartWithstrokeColors:strokeColorsArray3 lineWidth:11.0 endAngles:endAnglesArray3 labelCountText:positionNumber.floatValue];
        
    }
}
-(void)addLineChart:(NSArray *)ForecastArray
{
    //    ·         nextClosePrice: "-",[实际收盘价]
    //    ·         frcEndDate: "2014-08-27",[预测日期]
    //    ·         highPrice: "10.300",[预测价格]
    
    if (!ForecastArray || ![ForecastArray isKindOfClass:[NSArray class]] || ForecastArray.count == 0) {
        NSLog(@"传入参数 ForecastArray数据有误");
        return;
    }

    //x 轴上的值
    NSMutableArray *xAxisValues = [NSMutableArray array];// @[@"12.01", @"12.02", @"12.03",@"12.04", @"12.05", @"12.06",@"12.07"];
    //Y轴值的取值范围数组
    NSMutableArray *yAxisRelatedValuesArray = [NSMutableArray array];
    //Y轴值的取值范围数组
    NSMutableArray *yAxisValues = [NSMutableArray array];
    
    
    //预测价格曲线数组
    NSMutableArray *highPricePointsArray = [NSMutableArray array];
    //实际收盘价数组
    NSMutableArray *nextClosePricePointsArry = [NSMutableArray array];
    
    for (int i = 0; i < ForecastArray.count; i++) {
        NSDictionary *ForecastDic = [ForecastArray safeObjectAtIndex:i];
        //[实际收盘价]
        NSString *closePriceString =  [self getStringWithString:[ForecastDic objectForKeyNotNull:@"closePrice"]];
        //[预测日期]
        NSString *frcEndDateString = [self getDateStringWithString:[ForecastDic objectForKeyNotNull:@"frcEndDate"]];
        //预测价格
        NSString *highPriceString = [self getStringWithString:[ForecastDic objectForKeyNotNull:@"highPrice"]];

        //x轴
        if (frcEndDateString && frcEndDateString.length > 0) {
            [xAxisValues addObject:frcEndDateString];
            
            //增加y值数组
            [yAxisRelatedValuesArray addObject:closePriceString];

        }
        //实际收盘价点
        if ((frcEndDateString && frcEndDateString.length > 0) && closePriceString && closePriceString.length > 0  ) {
            CGPoint point = CGPointMake([frcEndDateString floatValue], [closePriceString floatValue]);
            [nextClosePricePointsArry addObject:[NSValue valueWithCGPoint:point]];
            
            //增加y值数组
            [yAxisRelatedValuesArray addObject:closePriceString];
        }
        //预测价格点
        if ((frcEndDateString && frcEndDateString.length > 0) && highPriceString && highPriceString.length > 0  ) {
            CGPoint point = CGPointMake([frcEndDateString floatValue], [highPriceString floatValue]);
            [highPricePointsArray addObject:[NSValue valueWithCGPoint:point]];
            
            //增加y值数组
            [yAxisRelatedValuesArray addObject:highPriceString];
        }
        
        
    }
    
    yAxisValues  = [self getYAxisValuesByRelatedArray:yAxisRelatedValuesArray];
    
    //x 轴的值
    self.lineChartView.xAxisValues = xAxisValues;
    //y 轴的值
    self.lineChartView.yAxisValues = yAxisValues;
    lineModel *plot1 = [[lineModel alloc] initWith:highPricePointsArray lineColor:[ColorTool colorWithRGB:@"#0b7dd5"] pointColor:[ColorTool colorWithRGB:@"#0b7dd5"] width:1 title:@"预测股价" titleFrame:CGRectMake(166.0f,15.0f, 50.0f, 11.0f)];

    lineModel *plot2 = [[lineModel alloc] initWith:nextClosePricePointsArry lineColor:[ColorTool colorWithRGB:@"#c9c9c9"] pointColor:[ColorTool colorWithRGB:@"#c9c9c9"] width:1 title:@"实际股价" titleFrame:CGRectMake(250.0f,15.0f,50.0f, 11.0f)] ;
    [self.lineChartView clearLines];
    [self.lineChartView addLine:plot1];
    [self.lineChartView addLine:plot2];
    [self.lineChartView draw];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - current page tool Method
-(NSNumber *)getNumberWithString:(NSString *)valueString
{
    if (!valueString || valueString.length == 0 || ![valueString floatValue] > 0) {
        return nil;
    }
    NSString *resultString = [NSString stringWithFormat:@"%0.2f",[valueString floatValue]];
    NSNumber *resultFloatNumber  = [NSNumber numberWithFloat:[resultString floatValue]];
    return resultFloatNumber;
}

-(NSString *)getStringWithString:(NSString *)valueString
{
    if (!valueString || valueString.length == 0 || ![valueString floatValue] > 0) {
        return nil;
    }
    NSString *resultString = [NSString stringWithFormat:@"%0.2f",[valueString floatValue]];
    return resultString;
}
-(NSString *)getDateStringWithString:(NSString *)valueString
{
    if (!valueString || valueString.length == 0) {
        return nil;
    }
    //原始数据格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:valueString];
    //结果格式
    NSDateFormatter *resultFormatter = [[NSDateFormatter alloc] init];
    [resultFormatter setDateFormat:@"MM.dd"];
    NSString *resultDateString = [resultFormatter stringFromDate:date];
    return resultDateString;
}


-(NSMutableArray *)getYAxisValuesByRelatedArray:(NSArray *)valueArrays
{
    NSMutableArray *yAxisValues = [NSMutableArray array];
//    valueArrays
    [valueArrays sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    float maxValue = [[valueArrays lastObject] floatValue];
    float minValue = [[valueArrays firstObject] floatValue];
    //建议是拿最高值和最低值各自乘以个+-10%，这样不至于最小值紧贴X轴
    maxValue = maxValue*(1 + 0.1);
    minValue = minValue*(1 - 0.1);
    float stepValue = (maxValue - minValue)/4;
    for (int i = 0; i <= 3; i++) {
        NSString *stepValueString = [NSString stringWithFormat:@"%0.2f",minValue + i*stepValue];
        [yAxisValues addObject:stepValueString];
    }
    return yAxisValues;
}

@end
