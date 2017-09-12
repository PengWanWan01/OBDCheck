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
    LogsModel *model;
    LineChartDataSet *set1;
    LineChartData *PartOnedata;
    LineChartData *PartTwodata;

}
@end

@implementation LogsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Logs" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    set1 = nil;
    PartOnedata = [[LineChartData alloc] initWithDataSet:set1];
    PartTwodata = [[LineChartData alloc] initWithDataSet:set1];

    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    NSArray* pAll = [LogsModel bg_findAll];
    for(LogsModel* logsmodel in pAll){
        NSLog(@"logsmodel.item1PID %@",logsmodel.item1PID  );
        model = logsmodel;
        if (model.item3Enabled == YES || model.item4Enabled == YES ) {
            [self initWithLogViewTwoPart];
        }else{
            [self initWithLogView];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
  

   }
- (void)btn{
    NSLog(@"1212");
    [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:100 withY:100];
}
 - (void)initWithLogView{
     [chartViewone removeFromSuperview];
     [chartViewTwo removeFromSuperview];
     chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 45-64)];
    [self.view addSubview:chartViewone];
     UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 20)];
     btn.backgroundColor = [UIColor redColor];
     [btn addTarget: self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:btn];

    [self initWithchartView:chartViewone Type:1];
    
    [self setDataCount:100 range:110 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item1PID withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:(model.item1Smoothing)];
     [self setDataCount:100 range:550 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item2PID withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:(model.item2Smoothing)];
     
    [chartViewone animateWithXAxisDuration:1];
     //设置当前可以看到的个数
     [chartViewone setVisibleXRangeMaximum:10];
     //设置当前开始的位置
     [chartViewone moveViewToX:15];
     
}
- (void)initWithLogViewTwoPart{
    [chartViewone removeFromSuperview];
    [chartViewTwo removeFromSuperview];
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, (MSHeight - 45-64)/2)];
    chartViewTwo = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, (MSHeight - 45-64)/2)];
    [self.view addSubview:chartViewone];
     [self.view addSubview:chartViewTwo];
    [self initWithchartView:chartViewone Type:1];
    [self initWithchartView:chartViewTwo Type:2];
    [self setDataCount:100 range:110 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item1PID withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:(model.item1Smoothing)];
    [self setDataCount:100 range:550 withView:chartViewone withdata:PartOnedata withPIDTiltle:model.item2PID withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:(model.item2Smoothing)];
    [self setDataCount:100 range:110 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:model.item3PID withLineColor:[ColorTools colorWithHexString:@"3F51B5"] withDependency:AxisDependencyLeft iSsmoothing:(model.item3Smoothing)];
    if (model.item4Enabled == YES) {
    [self setDataCount:100 range:550 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:model.item4PID withLineColor:[ColorTools colorWithHexString:@"FF9800"] withDependency:AxisDependencyRight iSsmoothing:(model.item4Smoothing)];
    }
    [chartViewone animateWithXAxisDuration:1];
    //设置当前可以看到的个数
    [chartViewone setVisibleXRangeMaximum:10];
    //设置当前开始的位置
    [chartViewone moveViewToX:15];
 
    [chartViewTwo animateWithXAxisDuration:1];
    //设置当前可以看到的个数
    [chartViewTwo setVisibleXRangeMaximum:10];
    //设置当前开始的位置
    [chartViewTwo moveViewToX:15];
}
//添加动态数据
- (void)updateChartData:(LineChartView *)view withData:(LineChartData *)linechartdata withIndex:(NSInteger)index  withX:(int)X withY:(int)Y
{
    
    
    [linechartdata addEntry:[[ChartDataEntry alloc]initWithX:X y:Y] dataSetIndex:index];
      [linechartdata notifyDataChanged];
        [view notifyDataSetChanged];
    NSLog(@"updateChartData%ld",(long)linechartdata.entryCount);

}

- (void)setDataCount:(int)count range:(double)range withView:(LineChartView *)view withdata:(LineChartData *)linechartdata withPIDTiltle:(NSString *)title withLineColor:(UIColor *)color withDependency:(AxisDependency)Dependency  iSsmoothing:(BOOL)smoothing
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range / 2.0;
        double val = (double) (arc4random_uniform(mult)) + 50;
        [yVals addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
        set1 = [[LineChartDataSet alloc] initWithValues:yVals label:title];
        set1.axisDependency = Dependency;
    NSLog(@"colorcolor%@",color);
    
     [set1 setColor:color];  
        set1.highlightColor = [UIColor clearColor]; //点击时候的颜色
        set1.drawCircleHoleEnabled = NO;
        set1.lineWidth = 2.0;//折线宽度
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
    if (smoothing == YES) {
         [set1 setDrawCubicEnabled:YES];
    }
       [linechartdata addDataSet:set1];
    
        [linechartdata setValueTextColor:UIColor.clearColor];
        [linechartdata setValueFont:[UIFont systemFontOfSize:9.f]];
        
        view.data = linechartdata;
        
    NSLog(@"%d",view.data.entryCount);
    
}

- (void)initWithchartView:(LineChartView *)view Type:(NSInteger)type{
    view.delegate = self;
    view.chartDescription.enabled = NO;
    view.dragEnabled = YES;
    [view setScaleEnabled:YES];
    view.pinchZoomEnabled = YES;
    view.drawGridBackgroundEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    view.gridBackgroundColor = [UIColor clearColor];
    
    ChartLegend *l = view.legend;
    l.form = ChartLegendFormLine;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.textColor = UIColor.whiteColor;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    ChartXAxis *xAxis = view.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.labelTextColor = UIColor.whiteColor;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.decimals = 6;
    xAxis.gridColor = [UIColor grayColor];
    
    ChartYAxis *leftAxis = view.leftAxis;
    leftAxis.labelTextColor = [UIColor whiteColor];
    leftAxis.axisMaximum = 200.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.drawAxisLineEnabled = YES;
    
    
    ChartYAxis *rightAxis = view.rightAxis;
    rightAxis.labelTextColor = [UIColor whiteColor];
    rightAxis.axisMaximum = 900.0;
    rightAxis.axisMinimum = -200.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.axisLineWidth = 2;
    
    if (type ==2) {
        [leftAxis setAxisLineColor:[ColorTools colorWithHexString:@"3F51B5"]];
        [rightAxis setAxisLineColor:[ColorTools colorWithHexString:@"FF9800"]];
        if (model.item4Enabled == NO) {
            [rightAxis setAxisLineColor:[UIColor clearColor]];
            rightAxis.labelTextColor = [UIColor clearColor];
        }

    }else{
        [leftAxis setAxisLineColor:[ColorTools colorWithHexString:@"E51C23"]];
        [rightAxis setAxisLineColor:[ColorTools colorWithHexString:@"54C44B"]];
    }
    leftAxis.axisLineWidth = 2;
    leftAxis.labelCount = 5;
    
    
   
    

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
