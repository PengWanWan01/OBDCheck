//
//  LogsController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "LogsController.h"
static dispatch_source_t _timer;

typedef NS_ENUM(NSInteger ,chartViewnumber)
{
    chartViewnumberone=0,   // 一种图表
    chartViewnumberTwo,    // 2种图表
   
};

@interface LogsController ()<TBarViewDelegate,ChartViewDelegate,BlueToothControllerDelegate>
{
    LineChartView *chartViewone ;
    LineChartView *chartViewTwo ;
    LineChartDataSet *set1;
    LineChartData *PartOnedata;
    LineChartData *PartTwodata;
    NSMutableArray *PID1dataSource;
    NSMutableArray *PID2dataSource;
    NSMutableArray *PID3dataSource;
    NSMutableArray *PID4dataSource;
    NSInteger sendNumber;
    NSInteger PID1indextag;
     NSInteger PID2indextag;
     NSInteger PID3indextag;
     NSInteger PID4indextag;
     BOOL isSave;
     TBarView *tbarView;
    NSInteger selectVC;
    NSMutableDictionary *listDic;
}
@property (nonatomic,strong) LogsController *oneVc;
@property (nonatomic,strong) TripsViewController *twoVC;
@property (nonatomic,strong) FilesViewController *ThreeVc;
@end

@implementation LogsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Logs" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    set1 = nil;
    PartOnedata = [[LineChartData alloc] initWithDataSet:set1];
    PartTwodata = [[LineChartData alloc] initWithDataSet:set1];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
  
        if ([LogsSetting sharedInstance].PID3Enable == YES || [LogsSetting sharedInstance].PID4Enable == YES ) {
            [self initWithLogViewTwoPartUI];
        }else{
            [self initWithLogViewUI];
        }
       [self initWithUI];
     PID1indextag =  0;
     PID2indextag =  0;
     PID3indextag =  0;
     PID4indextag =  0;
    isSave = NO;
    if (!(selectVC == 0)) {
        DLog(@"yes");
        [self reloadControlleView:selectVC];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PID1dataSource = [[NSMutableArray alloc]init];
    PID2dataSource = [[NSMutableArray alloc]init];
    PID3dataSource = [[NSMutableArray alloc]init];
    PID4dataSource = [[NSMutableArray alloc]init];

  
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
        if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        }else{
            DLog(@"竖屏");
            [self setVerticalFrame];
        }
    tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    if ([LogsSetting sharedInstance].PID3Enable == YES || [LogsSetting sharedInstance].PID4Enable == YES ) {
        chartViewone.frame = CGRectMake(0, 0, SCREEN_MIN, (SCREEN_MAX - 45-64)/2);
        if (IS_IPHONE_X) {
            chartViewone.frame = CGRectMake(0, 0, SCREEN_MIN, (SCREEN_MAX - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
        }
        chartViewTwo.frame =CGRectMake(0, CGRectGetMaxY(chartViewone.frame), SCREEN_MIN, (SCREEN_MAX - 45-64)/2);
        if (IS_IPHONE_X) {
            chartViewTwo.frame = CGRectMake(0, CGRectGetMaxY(chartViewone.frame), SCREEN_MIN, (SCREEN_MAX - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
        }
    }else{
        chartViewone.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX - 45-64);
        if (IS_IPHONE_X) {
            chartViewone.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34);
        }
    }
    
  
  
    
   
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    if ([LogsSetting sharedInstance].PID3Enable == YES || [LogsSetting sharedInstance].PID4Enable == YES ) {
        chartViewone.frame = CGRectMake(10, 0, (SCREEN_MAX-30)/2, (SCREEN_MIN - 45-64));
        if (IS_IPHONE_X) {
            chartViewone.frame = CGRectMake(10, 0,  (SCREEN_MAX-30)/2, (SCREEN_MIN - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34));
        }
        chartViewTwo.frame =CGRectMake(CGRectGetMaxX(chartViewone.frame)+10, 0, (SCREEN_MAX-30)/2, (SCREEN_MIN - 45-64));
        if (IS_IPHONE_X) {
            chartViewTwo.frame = CGRectMake(CGRectGetMaxX(chartViewone.frame)+10, 0, (SCREEN_MAX-30)/2, (SCREEN_MIN - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34));
        }
    }else{
        chartViewone.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN - 45-64);
        if (IS_IPHONE_X) {
            chartViewone.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34);
        }
    }
    

    
}
- (void)btn{
    [self.blueTooth SendData:[self hexToBytes:@"303130640D"]];
//    [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:100 withY:100];
}
 - (void)initWithLogView{
     DLog(@"弹出一个图");
     [chartViewone removeFromSuperview];
     [chartViewTwo removeFromSuperview];
     chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 45-64)];
     if (IS_IPHONE_X) {
         chartViewone.frame = CGRectMake(0, 0, MSWidth, MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34);
     }
    [self.view addSubview:chartViewone];
    [self initWithchartView:chartViewone Type:1];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"" withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:([LogsSetting sharedInstance].PID1Smoothing)];
     [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"" withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:([LogsSetting sharedInstance].PID2Smoothing)];
//         [chartViewone animateWithXAxisDuration:5];
//         //设置当前可以看到的个数
//         [chartViewone setVisibleXRangeMaximum:10];
//         //设置当前开始的位置
//         [chartViewone moveViewToX:0];
//     UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 100, 20)];
//     btn.backgroundColor = [UIColor redColor];
//     [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventAllEvents];
//     [chartViewone addSubview:btn];
}
- (void)initWithLogViewTwoPart{
    DLog(@"弹出2个图");
    [chartViewone removeFromSuperview];
    [chartViewTwo removeFromSuperview];
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, (MSHeight - 45-64)/2)];
    if (IS_IPHONE_X) {
        chartViewone.frame = CGRectMake(0, 0, MSWidth, (MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
    }
    chartViewTwo = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, (MSHeight - 45-64)/2)];
    if (IS_IPHONE_X) {
        chartViewTwo.frame = CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, (MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
    }
    [self.view addSubview:chartViewone];
     [self.view addSubview:chartViewTwo];
    [self initWithchartView:chartViewone Type:1];
    [self initWithchartView:chartViewTwo Type:2];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"vehicle speed" withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:([LogsSetting sharedInstance].PID1Smoothing)];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"rotate speed" withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:([LogsSetting sharedInstance].PID2Smoothing)];
    [self setDataCount:0 range:0 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:@"water temperature" withLineColor:[ColorTools colorWithHexString:@"3F51B5"] withDependency:AxisDependencyLeft iSsmoothing:([LogsSetting sharedInstance].PID3Smoothing)];
    if ([LogsSetting sharedInstance].PID4Enable == YES) {
    [self setDataCount:0 range:0 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:@"throttle position" withLineColor:[ColorTools colorWithHexString:@"FF9800"] withDependency:AxisDependencyRight iSsmoothing:([LogsSetting sharedInstance].PID4Smoothing)];
    }
//    [chartViewone animateWithXAxisDuration:5];
//    //设置当前可以看到的个数
//    [chartViewone setVisibleXRangeMaximum:10];
//    //设置当前开始的位置
//    [chartViewone moveViewToX:0];
//
//    [chartViewTwo animateWithXAxisDuration:5];
//    //设置当前可以看到的个数
//    [chartViewTwo setVisibleXRangeMaximum:10];
//    //设置当前开始的位置
//    [chartViewTwo moveViewToX:0];
}
//添加动态数据 index代表第几根折线
- (void)updateChartData:(LineChartView *)view withData:(LineChartData *)linechartdata withIndex:(NSInteger)index  withX:(int)X withY:(int)Y
{
    [linechartdata addEntry:[[ChartDataEntry alloc]initWithX:X y:Y] dataSetIndex:index];
    //设置当前可以看到的个数
//    [view setVisibleXRangeMaximum:10];
    //设置当前开始的位置
//    [view moveViewToX:X - 10];
      [linechartdata notifyDataChanged];
    [view notifyDataSetChanged];
    DLog(@"updateChartData%ld",(long)linechartdata.entryCount);

}
// 设置其中一条折线的内容，数据，颜色，宽度
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
     [set1 setColor:color];  
        set1.highlightColor = [UIColor clearColor]; //点击时候的颜色
        set1.drawCircleHoleEnabled = NO;
        set1.lineWidth = 2.0;//折线宽度
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
    if (smoothing == YES) {
        [set1 setMode:LineChartModeCubicBezier];
    }
    [linechartdata addDataSet:set1];
        [linechartdata setValueTextColor:UIColor.clearColor];
        [linechartdata setValueFont:[UIFont systemFontOfSize:9.f]];
        view.data = linechartdata;
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
//设置左边的Y轴
    ChartYAxis *leftAxis = view.leftAxis;
    leftAxis.labelTextColor = [UIColor whiteColor];
//    leftAxis.axisMaximum = 200.0;
//    leftAxis.axisMinimum = 0.0;
    leftAxis.drawAxisLineEnabled = YES;
// 设置右边的Y轴
    ChartYAxis *rightAxis = view.rightAxis;
    rightAxis.labelTextColor = [UIColor whiteColor];
//    rightAxis.axisMaximum = 900.0;
//    rightAxis.axisMinimum = -200.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.axisLineWidth = 2;
    if (type ==2) {
        [leftAxis setAxisLineColor:[ColorTools colorWithHexString:@"3F51B5"]];
        [rightAxis setAxisLineColor:[ColorTools colorWithHexString:@"FF9800"]];
        if ([LogsSetting sharedInstance ].PID4Enable == NO) {
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
    UIView * topView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, self.navigationController.navigationBar.frame.size.height)];
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, topView.frame.size.height)];
    [startBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 50, topView.frame.size.height)];
     [stopBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
     [stopBtn addTarget:self action:@selector(stopBtn) forControlEvents:UIControlEventTouchUpInside];
    
        [topView addSubview:stopBtn];
        [topView addSubview:startBtn];
    self.navigationItem.titleView = topView;
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
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
- (void)initWithLogViewUI{
    DLog(@"弹出一个图");
    [chartViewone removeFromSuperview];
    [chartViewTwo removeFromSuperview];
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight - 45-64)];
    if (IS_IPHONE_X) {
        chartViewone.frame = CGRectMake(0, 0, MSWidth, MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34);
    }
    [self.view addSubview:chartViewone];
    [self initWithchartView:chartViewone Type:1];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"vehicle speed" withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:([LogsSetting sharedInstance ].PID1Smoothing)];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"rotate speed" withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:([LogsSetting sharedInstance ].PID2Smoothing)];
    
}
- (void)initWithLogViewTwoPartUI{
    DLog(@"弹出2个图");
    [chartViewone removeFromSuperview];
    [chartViewTwo removeFromSuperview];
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, (MSHeight - 45-64)/2)];
    if (IS_IPHONE_X) {
        chartViewone.frame = CGRectMake(0, 0, MSWidth, (MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
    }
    chartViewTwo = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, (MSHeight - 45-64)/2)];
    if (IS_IPHONE_X) {
        chartViewTwo.frame = CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, (MSHeight - 45-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -34)/2);
    }
    [self.view addSubview:chartViewone];
    [self.view addSubview:chartViewTwo];
    [self initWithchartView:chartViewone Type:1];
    [self initWithchartView:chartViewTwo Type:2];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"vehicle speed" withLineColor:[ColorTools colorWithHexString:@"E51C23"] withDependency:AxisDependencyLeft iSsmoothing:([LogsSetting sharedInstance].PID1Smoothing)];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"rotate speed" withLineColor:[ColorTools colorWithHexString:@"54C44B"] withDependency:AxisDependencyRight iSsmoothing:([LogsSetting sharedInstance].PID2Smoothing)];
    [self setDataCount:0 range:0 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:@"water temperature" withLineColor:[ColorTools colorWithHexString:@"3F51B5"] withDependency:AxisDependencyLeft iSsmoothing:([LogsSetting sharedInstance].PID3Smoothing)];
    if ([LogsSetting sharedInstance].PID4Enable == YES) {
        [self setDataCount:0 range:0 withView:chartViewTwo withdata:PartTwodata withPIDTiltle:@"throttle position" withLineColor:[ColorTools colorWithHexString:@"FF9800"] withDependency:AxisDependencyRight iSsmoothing:([LogsSetting sharedInstance].PID4Smoothing)];
    }
}
- (void)back{
    [self SaveDataSource];
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)rightBarButtonClick{
    [self SaveDataSource];
    LogSetViewController *vc = [[LogSetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 底部Tabbar的按钮事件
//根据字典中是否存在相关页面对应的key，没有的话存储
- (UIViewController *)controllerForSegIndex:(NSUInteger)segIndex {
    NSString *keyName = [NSString stringWithFormat:@"VC_%ld",(unsigned long)segIndex];
    
    UIViewController *controller = (UIViewController *)[listDic objectForKey:keyName];
    
    if (!controller) {
        if (segIndex == 0) {//
            controller = self.oneVc;
            
        }else if (segIndex == 1) {//
            controller = self.twoVC;
        }
        else if (segIndex == 2) {//
            controller = self.ThreeVc;
        }
        [listDic setObject:controller forKey:keyName];
    }
    
    return controller;
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    [self SaveDataSource];
    DLog(@"%ld",touchSelectNumber);
    [self reloadControlleView:touchSelectNumber];
    switch (touchSelectNumber) {
        case 0:
        {
            tbarView.isSelectNumber = 0;
        }
            break;
        case 1:
        {
            tbarView.isSelectNumber = 1;
        }
            break;
        case 2:
        {
            tbarView.isSelectNumber = 2;
        }
            break;
        default:
            break;
    }
    selectVC =  tbarView.isSelectNumber;
}
- (void)reloadControlleView:(NSInteger)VCindex{
    [_oneVc.view   removeFromSuperview];
    [_twoVC.view removeFromSuperview];
    [_ThreeVc.view removeFromSuperview];
    UIViewController *controller = [self controllerForSegIndex:VCindex];
    [self.view addSubview:controller.view];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 3;
    tbarView.isSelectNumber = selectVC;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_normal",@"trips_normal",@"file_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_highlight",@"trips_highlight",@"file_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Graphs",@"Trips",@"Files", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
}
#pragma mark 点击开始点击停止
- (void)stopBtn{
  
    [self SaveDataSource];
}
#pragma mark 保存内容LOGS到数据库
-(void)SaveDataSource{
    if (isSave == YES) {
    self.blueTooth.stopSend = YES;
    [[LogsSetting sharedInstance]initWithlogswith:PID1dataSource with:PID2dataSource with:PID3dataSource with:PID4dataSource];
    
    NSArray *arr = [LogsModel findAll];
    
    DLog(@"logs数据库%@", arr.lastObject);
    LogsModel *model = arr.lastObject;
    DLog(@"数据%@%@%@%@",model.PID1dataSource,model.PID2dataSource,model.PID3dataSource,model.PID4dataSource);
        isSave = NO;
    }
}
#pragma mark 点击开始  //发送蓝牙指令
- (void)startBtn{
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    //发送：ATH1=》发送：ATSP0=》发送：0100=》
    DLog(@"发送开始的车速指令");
    sendNumber = 0;
    //发送车速
    [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
    set1 = nil;
    PartOnedata = [[LineChartData alloc] initWithDataSet:set1];
    PartTwodata = [[LineChartData alloc] initWithDataSet:set1];
    PID1dataSource = [[NSMutableArray alloc]init];
    PID2dataSource = [[NSMutableArray alloc]init];
    PID3dataSource = [[NSMutableArray alloc]init];
    PID4dataSource = [[NSMutableArray alloc]init];

        if ([LogsSetting sharedInstance].PID3Enable == YES || [LogsSetting sharedInstance].PID4Enable == YES ) {
            [self initWithLogViewTwoPart];
        }else{
            [self initWithLogView];
        }

}

#pragma mark蓝牙代理协议，处理信息
- (void)getDeviceInfo:(BELInfo *)info{
    
}
#pragma mark 收到数据
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
    DLog(@"收到收到%@",data);
    
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
     string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
     string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
     DLog(@"最后的数据%@,数据长度%ld",string,(unsigned long)string.length);
    NSString *VehicleSpeedStr = [BlueTool isVehicleSpeed:string];
    NSString *RotationalStr = [BlueTool isRotational:string];
    NSString *WatertemperatureStr = [BlueTool isWatertemperature:string];
    NSString *ThrottlePositionStr = [BlueTool isThrottlePosition:string];
    DLog(@"车速%@",VehicleSpeedStr);
    DLog(@"转速%@",RotationalStr);
    DLog(@"水温%@",WatertemperatureStr);
    DLog(@"TF%@",ThrottlePositionStr);
   if (!(VehicleSpeedStr == nil)) {
            [PID1dataSource addObject:VehicleSpeedStr];
            DLog(@"%@",PID1dataSource);
            //得到车速之后，发送转速
            [self.blueTooth SendData:[self hexToBytes:@"303130630D"]];
       
    }
    if (!(RotationalStr == nil)) {
            [PID2dataSource addObject:RotationalStr];
            DLog(@"%@",PID2dataSource);
            //发送水温
            [self.blueTooth SendData:[self hexToBytes:@"303130350D"]];
      
    }
    if (!(WatertemperatureStr == nil)) {
            [PID3dataSource addObject:WatertemperatureStr];
            DLog(@"%@",PID3dataSource);
            //得到水温之后，发送TF
            [self.blueTooth SendData:[self hexToBytes:@"303131310D"]];

    }
   if (!(ThrottlePositionStr == nil)) {
            [PID4dataSource addObject:ThrottlePositionStr];
            DLog(@"%@",PID4dataSource);
            [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:(int)PID1indextag  withY:[PID1dataSource[PID1indextag] intValue]];
            [self updateChartData:chartViewone withData:PartOnedata withIndex:1 withX:(int)PID2indextag  withY:[PID2dataSource[PID2indextag] intValue]];
            [self updateChartData:chartViewTwo withData:PartTwodata withIndex:0 withX:(int)PID3indextag  withY:[PID3dataSource[PID3indextag] intValue]];
             [self updateChartData:chartViewTwo withData:PartTwodata withIndex:1 withX:(int)PID4indextag  withY:[PID4dataSource[PID4indextag] intValue]];
            ++PID1indextag;
            ++PID2indextag;
            ++PID3indextag;
            ++PID4indextag;
            isSave = YES;
            //得到TF之后，发送车速
            [self.blueTooth SendData:[self hexToBytes:@"303130640D"]];
       
    }
 

}
-(void)BlueToothState:(BlueToothState)state{
    
    
}
-(NSData*) hexToBytes :(NSString*)hex{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hex.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hex substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
-(LogsController *)oneVC{
    if (_oneVc == nil) {
        _oneVc = [[LogsController alloc] init];
    }
    return _oneVc;
}


-(TripsViewController *)twoVC{
    if (_twoVC == nil) {
        _twoVC = [[TripsViewController alloc] init];
    }
    return _twoVC;
}
-(FilesViewController *)ThreeVc{
    if (_ThreeVc == nil) {
        _ThreeVc = [[FilesViewController alloc] init];
    }
    return _ThreeVc;
}

@end
