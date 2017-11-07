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
  
        if ([LogsSetting sharedInstance].PID3Enable == YES || [LogsSetting sharedInstance].PID4Enable == YES ) {
            [self initWithLogViewTwoPartUI];
        }else{
            [self initWithLogViewUI];
        }
   
     PID1indextag =  0;
     PID2indextag =  0;
     PID3indextag =  0;
     PID4indextag =  0;
    isSave = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PID1dataSource = [[NSMutableArray alloc]init];
    PID2dataSource = [[NSMutableArray alloc]init];
    PID3dataSource = [[NSMutableArray alloc]init];
    PID4dataSource = [[NSMutableArray alloc]init];

//    for (NSInteger i = 11; i < 3600; i++) {
//        [XdataSource addObject:[NSString stringWithFormat:@"%ld",(long)i]];
//    }
    [self initWithUI];
  
}
- (void)btn{
    [self.blueTooth SendData:[self hexToBytes:@"303130640D"]];
//    [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:100 withY:100];
}
 - (void)initWithLogView{
     NSLog(@"弹出一个图");
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
    NSLog(@"弹出2个图");
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
    NSLog(@"updateChartData%ld",(long)linechartdata.entryCount);

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
         [set1 setDrawCubicEnabled:YES];
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
    
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
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
    NSLog(@"弹出一个图");
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
    NSLog(@"弹出2个图");
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
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
     [self SaveDataSource];
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
#pragma mark 点击开始点击停止
- (void)stopBtn{
  
    [self SaveDataSource];
}
#pragma mark 保存内容LOGS到数据库
-(void)SaveDataSource{
    if (isSave == YES) {
        //发送ATDP指令；
    [self.blueTooth SendData:[BlueTool hexToBytes:@"415444500D"]];
    [[LogsSetting sharedInstance]initWithlogswith:PID1dataSource with:PID2dataSource with:PID3dataSource with:PID4dataSource];
    
    NSArray *arr = [LogsModel bg_findAll];
    
    NSLog(@"logs数据库%@", arr.lastObject);
    LogsModel *model = arr.lastObject;
    NSLog(@"数据%@%@%@%@",model.PID1dataSource,model.PID2dataSource,model.PID3dataSource,model.PID4dataSource);
        isSave = NO;
    }
}
#pragma mark 点击开始  //发送蓝牙指令
- (void)startBtn{
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    //发送：ATH1=》发送：ATSP0=》发送：0100=》
    NSLog(@"发送开始的车速指令");
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
    NSLog(@"收到收到%@",data);
    
    NSLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
     string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
     string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
     NSLog(@"最后的数据%@,数据长度%ld",string,(unsigned long)string.length);
    NSString *VehicleSpeedStr = [BlueTool isVehicleSpeed:string];
    NSString *RotationalStr = [BlueTool isRotational:string];
    NSString *WatertemperatureStr = [BlueTool isWatertemperature:string];
    NSString *ThrottlePositionStr = [BlueTool isThrottlePosition:string];
    NSLog(@"车速%@",VehicleSpeedStr);
    NSLog(@"转速%@",RotationalStr);
    NSLog(@"水温%@",WatertemperatureStr);
    NSLog(@"TF%@",ThrottlePositionStr);
   if (!(VehicleSpeedStr == nil)) {
            [PID1dataSource addObject:VehicleSpeedStr];
            NSLog(@"%@",PID1dataSource);
            //得到车速之后，发送转速
            [self.blueTooth SendData:[self hexToBytes:@"303130630D"]];
       
    }
    if (!(RotationalStr == nil)) {
            [PID2dataSource addObject:RotationalStr];
            NSLog(@"%@",PID2dataSource);
            //发送水温
            [self.blueTooth SendData:[self hexToBytes:@"303130350D"]];
      
    }
    if (!(WatertemperatureStr == nil)) {
            [PID3dataSource addObject:WatertemperatureStr];
            NSLog(@"%@",PID3dataSource);
            //得到水温之后，发送TF
            [self.blueTooth SendData:[self hexToBytes:@"303131310D"]];

    }
   if (!(ThrottlePositionStr == nil)) {
            [PID4dataSource addObject:ThrottlePositionStr];
            NSLog(@"%@",PID4dataSource);
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
@end
