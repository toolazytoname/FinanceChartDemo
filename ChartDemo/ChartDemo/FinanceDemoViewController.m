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
    [self addLabelSubviews];
    [self addPieChart];
    [self addLineChart];
}


-(void)addLabelSubviews
{
    self.topLeftLabel.font = [UIFont systemFontOfSize:11.5];
    self.topLeftLabel.textColor = [ColorTool colorWithRGB:@"#666666"];
    
    NSString *topRightString = [NSString stringWithFormat:@"收盘价: %0.2f",6.25f];
    NSMutableAttributedString *topRightStringAtti = [[NSMutableAttributedString alloc] initWithString:topRightString];
    [topRightStringAtti addAttribute:NSForegroundColorAttributeName value:[ColorTool colorWithRGB:@"#666666"]  range:NSMakeRange(0, 4)];
    [topRightStringAtti addAttribute:NSForegroundColorAttributeName value:[ColorTool colorWithRGB:@"#0b7dd5"]  range:NSMakeRange(4, topRightString.length - 4)];
    self.topRightLabel.font = [UIFont systemFontOfSize:11.5];
    self.topRightLabel.attributedText = topRightStringAtti;
    
    self.leftPieTopLabel.font = [UIFont systemFontOfSize:8.5];
    self.leftPieTopLabel.textColor = [ColorTool colorWithRGB:@"#a3a3a3"];
    
    NSMutableAttributedString *middlePieTopStringAtti = [[NSMutableAttributedString alloc] initWithString:@"昨收" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#a3a3a3"],NSForegroundColorAttributeName, nil]];
    [middlePieTopStringAtti appendAttributedString: [[NSAttributedString alloc] initWithString:@"[6.15]" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#0b7dd5"],NSForegroundColorAttributeName, nil]]];
    [middlePieTopStringAtti appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@"现价" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorTool colorWithRGB:@"#a3a3a3"],NSForegroundColorAttributeName, nil]]];
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
-(void)addPieChart
{
    //上涨
    NSArray *strokeColorsArray1 = [NSArray arrayWithObjects:[ColorTool colorWithRGB:@"#1067cb"], nil];
    NSArray *endAnglesArray1 = [NSArray arrayWithObjects:@0.75, nil];
    [self.leftPieChartView strokeChartWithstrokeColors:strokeColorsArray1 lineWidth:11.0 endAngles:endAnglesArray1 labelCountText:0.75];
    
    //涨幅
    NSArray *strokeColorsArray = [NSArray arrayWithObjects:[ColorTool colorWithRGB:@"#932b67"],[ColorTool colorWithRGB:@"#dd64aa"], nil];
    NSArray *endAnglesArray = [NSArray arrayWithObjects:@1,@0.5, nil];
    [self.middlePieChartView strokeChartWithstrokeColors:strokeColorsArray lineWidth:11.0 endAngles:endAnglesArray labelCountText:0.5];
    
    //最优仓位
    NSArray *strokeColorsArray3 = [NSArray arrayWithObjects:[ColorTool colorWithRGB:@"#ff9000"],nil];
    NSArray *endAnglesArray3 = [NSArray arrayWithObjects:@0.3, nil];
    [self.rightPieChartView strokeChartWithstrokeColors:strokeColorsArray3 lineWidth:11.0 endAngles:endAnglesArray3 labelCountText:0.3];
}

-(void)addLineChart
{
    //折线图
    NSArray *xAxisValues = @[@"12.01", @"12.02", @"12.03",@"12.04", @"12.05", @"12.06",@"12.07"];
    
//    建议是拿最高值和最低值各自乘以个+-10%，这样不至于最小值紧贴X轴
    NSArray *yAxisValues = @[@"12.00", @"12.40", @"12.80",@"13.20"];
    self.lineChartView.maintitle = @"7月预测对比曲线";
    self.lineChartView.maintitleRect = CGRectMake(28.0, 15, 100, 11);
    self.lineChartView.orignalPoint = CGPointMake(48.0f, 135.0f);
    self.lineChartView.xAxisLength = 249.0f;
    self.lineChartView.yAxisLength = 85.0f;
    self.lineChartView.xAxisValues = xAxisValues;
    self.lineChartView.yAxisValues = yAxisValues;
    
    // line 1
    NSArray *plot1YValues = @[@"12.10", @"12.50", @"12.40",@"13.00", @"12.30", @"12.90",@"13.20"];
    NSMutableArray *pointArray = [NSMutableArray array];
    for (int i = 0; i < self.lineChartView.xAxisValues.count; i++) {
        CGPoint point = CGPointMake([[self.lineChartView.xAxisValues objectAtIndex:i] floatValue], [[plot1YValues objectAtIndex:i] floatValue]);
        [pointArray addObject:[NSValue valueWithCGPoint:point]];
    }
    lineModel *plot1 = [[lineModel alloc] initWith:pointArray lineColor:[ColorTool colorWithRGB:@"#0b7dd5"] pointColor:[ColorTool colorWithRGB:@"#0b7dd5"] width:1 title:@"预测股价" titleFrame:CGRectMake(166.0f,15.0f, 50.0f, 11.0f)];
    [self.lineChartView addLine:plot1];
    
    //line 2
    NSArray *plot2YValues = @[@"12.20", @"12.40", @"12.50",@"12.90", @"12.30", @"12.00",@"13.00"];
    NSMutableArray *point2Array = [NSMutableArray array];
    for (int i = 0; i < self.lineChartView.xAxisValues.count; i++) {
        CGPoint point = CGPointMake([[self.lineChartView.xAxisValues objectAtIndex:i] floatValue], [[plot2YValues objectAtIndex:i] floatValue]);
        [point2Array addObject:[NSValue valueWithCGPoint:point]];
    }
    lineModel *plot2 = [[lineModel alloc] initWith:point2Array lineColor:[ColorTool colorWithRGB:@"#c9c9c9"] pointColor:[ColorTool colorWithRGB:@"#c9c9c9"] width:1 title:@"现实股价" titleFrame:CGRectMake(250.0f,15.0f,50.0f, 11.0f)] ;
    [self.lineChartView addLine:plot2];
    
    [self.lineChartView draw];
}

-(IBAction)startAnimation:(id)sender
{
    [self.leftPieChartView startAnimation];
    [self.middlePieChartView startAnimation];
    [self.rightPieChartView startAnimation];
    
    [self.lineChartView startAnimation];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
