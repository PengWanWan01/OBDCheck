//
//  LogsController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "LogsController.h"
typedef NS_ENUM(NSInteger ,chartViewnumber)
{
    chartViewnumberone=0,   // 一种图表
    chartViewnumberTwo,    // 2种图表
};

@interface LogsController ()<TBarViewDelegate,ChartViewDelegate>
{
    LineChartView *chartViewone ;
    LineChartView *chartViewTwo ;

}
@end

@implementation LogsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Logs" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithLogView];
    [self initWithUI];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 20)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget: self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btn{
    NSLog(@"1212");
    [self updateChartData];
}
 - (void)initWithLogView{
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 45-64)];
    [self.view addSubview:chartViewone];
    chartViewone.delegate = self;
    
    chartViewone.chartDescription.enabled = NO;
    
    chartViewone.dragEnabled = YES;
    [chartViewone setScaleEnabled:YES];
    chartViewone.pinchZoomEnabled = YES;
    chartViewone.drawGridBackgroundEnabled = YES;
    chartViewone.backgroundColor = [UIColor clearColor];
    chartViewone.gridBackgroundColor = [UIColor clearColor];
    //    chartView.highlightPerTapEnabled = NO;
    
    ChartLegend *l = chartViewone.legend;
    l.form = ChartLegendFormLine;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.textColor = UIColor.whiteColor;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    [self initWithchartType:1];
    
    [self setDataCount:100 range:110];
    
    [chartViewone animateWithXAxisDuration:1];
     //设置当前可以看到的个数
     [chartViewone setVisibleXRangeMaximum:10];
     //设置当前开始的位置
     [chartViewone moveViewToX:15];
     
}
- (void)updateChartData
{
    
    chartViewone.frame  = CGRectMake(0, 0, MSWidth +10, chartViewone.frame.size.height);
    [self setDataCount:110 range:100];
    [chartViewone setNeedsDisplay];
    NSLog(@"widthwidth%f",chartViewone.frame.size.width);
    
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range / 2.0;
        double val = (double) (arc4random_uniform(mult)) + 50;
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    for (int i = 0; i < count - 1; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) + 450;
        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    for (int i = 0; i < count; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) + 500;
        [yVals3 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    LineChartDataSet *set1 = nil, *set2 = nil, *set3 = nil;
    
    if (chartViewone.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)chartViewone.data.dataSets[0];
        set2 = (LineChartDataSet *)chartViewone.data.dataSets[1];
        set3 = (LineChartDataSet *)chartViewone.data.dataSets[2];
        set1.values = yVals1;
        set2.values = yVals2;
        set3.values = yVals3;
        [chartViewone.data notifyDataChanged];
        [chartViewone notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet 1"];
        set1.axisDependency = AxisDependencyLeft;
        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = NO;
        set1.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
        
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        
        set2 = [[LineChartDataSet alloc] initWithValues:yVals2 label:@"DataSet 2"];
        set2.axisDependency = AxisDependencyRight;
        [set2 setColor:UIColor.redColor];
        set2.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
        
        set2.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set2.drawCirclesEnabled = NO;//是否绘制拐点
        
        set3 = [[LineChartDataSet alloc] initWithValues:yVals3 label:@"DataSet 3"];
        set3.axisDependency = AxisDependencyRight;
        [set3 setColor:UIColor.yellowColor];
        set3.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
        set3.valueTextColor = [UIColor clearColor];
        set3.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set3.drawCirclesEnabled = NO;//是否绘制拐点
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        [dataSets addObject:set3];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.clearColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        
        chartViewone.data = data;
    }
}

- (void)initWithchartType:(NSInteger )type{
    ChartXAxis *xAxis = chartViewone.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.labelTextColor = UIColor.whiteColor;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.decimals = 6;
    xAxis.gridColor = [UIColor grayColor];
    
    ChartYAxis *leftAxis = chartViewone.leftAxis;
    leftAxis.labelTextColor = [UIColor whiteColor];
    leftAxis.axisMaximum = 200.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawAxisLineEnabled = YES;
    [leftAxis setAxisLineColor:[UIColor redColor]];
    leftAxis.axisLineWidth = 2;
    leftAxis.labelCount = 5;
    ChartYAxis *rightAxis = chartViewone.rightAxis;
    rightAxis.labelTextColor = [UIColor whiteColor];
    rightAxis.axisMaximum = 900.0;
    rightAxis.axisMinimum = -200.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = YES;
    [rightAxis setAxisLineColor:[UIColor greenColor]];
    rightAxis.axisLineWidth = 2;
    

}

- (void)initWithUI{
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 45-64, MSWidth, 45)];
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 3;
    tbarView.isSelectNumber = 0;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_normal",@"trips_normal",@"file_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_highlight",@"trips_highlight",@"file_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Graphs",@"Trips",@"Files", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
}
- (void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)rightBarButtonClick{
    LogSetViewController *vc = [[LogSetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            LogsController *vc = [[LogsController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            TripsViewController *vc = [[TripsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            FilesViewController *vc = [[FilesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }

}


@end
