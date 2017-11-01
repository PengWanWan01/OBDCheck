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
    NSLog(@"1212");
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
    
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 45*KHeightmultiple-64, MSWidth, 45*KHeightmultiple)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 45*KHeightmultiple-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height-34,MSWidth , 45*KHeightmultiple);
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
    //假如定时器存在，才把它停止
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)rightBarButtonClick{
    if (_timer) {
     dispatch_source_cancel(_timer);
    }
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
#pragma mark 点击开始点击停止
- (void)stopBtn{
  
        //发送ATDP指令；
         [self.blueTooth SendData:[BlueTool hexToBytes:@"415444500D"]];
        [[LogsSetting sharedInstance]initWithlogswith:PID1dataSource with:PID2dataSource with:PID3dataSource with:PID4dataSource];
    
        NSArray *arr = [LogsModel bg_findAll];
   
        NSLog(@"logs数据库%@", arr.lastObject);
    LogsModel *model = arr.lastObject;
    NSLog(@"数据%@%@%@%@",model.PID1dataSource,model.PID2dataSource,model.PID3dataSource,model.PID4dataSource);
   
  
   
    
}
#pragma mark 点击开始  //发送蓝牙指令
- (void)startBtn{
    set1 = nil;
    PartOnedata = [[LineChartData alloc] initWithDataSet:set1];
    PartTwodata = [[LineChartData alloc] initWithDataSet:set1];
    PID1dataSource = [[NSMutableArray alloc]init];
 
        if ([LogsSetting sharedInstance].PID3Enable == YES || [LogsSetting sharedInstance].PID4Enable == YES ) {
            [self initWithLogViewTwoPart];
        }else{
            [self initWithLogView];
        }
   
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    //发送：ATH1=》发送：ATSP0=》发送：0100=》
    NSLog(@"发送开始的三条指令");
    sendNumber = 0;
    //发送车速
    [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
  
    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, -30, 200, 40)];
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

//代理协议，处理信息
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
    if (string.length>14 && [[string substringToIndex:8] isEqualToString:@"83F11141"]){

        NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
        CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
        //车速添加到数组
        if ([Commond isEqualToString:@"0D"]) {
            //得到车速大小
            NSString *str = [NSString stringWithFormat:@"%f",[BlueTool getVehicleSpeed:thefloat]];
            NSLog(@"车速%@",str);
            [PID1dataSource addObject:str];
            NSLog(@"%@",PID1dataSource);
            //得到车速之后，发送转速
            [self.blueTooth SendData:[self hexToBytes:@"303130630D"]];
           
        }
        
    }
    if (string.length>16 && [[string substringToIndex:8] isEqualToString:@"84F11141"]){
        NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
        CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
         CGFloat theNextfloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(12, 2)]]floatValue];
        //转速添加到数组
        if ([Commond isEqualToString:@"0C"]) {
           //得到转速大小
            NSString *str = [NSString stringWithFormat:@"%f",[BlueTool getRotational:thefloat with:theNextfloat]];
            NSLog(@"转速%@",str);
            [PID2dataSource addObject:str];
            NSLog(@"%@",PID2dataSource);
            //发送水温
            [self.blueTooth SendData:[self hexToBytes:@"303130350D"]];
        }
       
    }
    if (string.length>14 && [[string substringToIndex:8] isEqualToString:@"83F11141"]){
        //得到水温
        NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
        CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
        //水温添加到数组
        if ([Commond isEqualToString:@"05"]) {
            
            NSString *str = [NSString stringWithFormat:@"%f",[BlueTool getWatertemperature:thefloat]];
            NSLog(@"水温%@",str);
            [PID3dataSource addObject:str];
            NSLog(@"%@",PID3dataSource);
            //得到水温之后，发送TF
            [self.blueTooth SendData:[self hexToBytes:@"303131310D"]];
        }
    }
    if (string.length>14 && [[string substringToIndex:8] isEqualToString:@"83F11141"]){
        //得到水温
        NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
        CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
        //TF添加到数组
        if ([Commond isEqualToString:@"11"]) {
            
            NSString *str = [NSString stringWithFormat:@"%f",[BlueTool getThrottlePosition:thefloat]];
            NSLog(@"TF%@",str);
            [PID4dataSource addObject:str];
            NSLog(@"%@",PID4dataSource);
            [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:(int)PID1indextag  withY:[PID1dataSource[PID1indextag] intValue]];
            [self updateChartData:chartViewone withData:PartOnedata withIndex:1 withX:(int)PID2indextag  withY:[PID2dataSource[PID2indextag] intValue]];
            [self updateChartData:chartViewTwo withData:PartTwodata withIndex:0 withX:(int)PID3indextag  withY:[PID3dataSource[PID3indextag] intValue]];
             [self updateChartData:chartViewTwo withData:PartTwodata withIndex:1 withX:(int)PID4indextag  withY:[PID4dataSource[PID4indextag] intValue]];
            ++PID1indextag;
            ++PID2indextag;
            ++PID3indextag;
            ++PID4indextag;
            //得到TF之后，发送车速
            [self.blueTooth SendData:[self hexToBytes:@"303130640D"]];
        }
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
