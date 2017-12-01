//
//  PerformancesViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformancesViewController.h"

@interface PerformancesViewController ()<ChartViewDelegate,BlueToothControllerDelegate>
{
    UIButton *startBtn;
    UIButton *reportBtn;
     LineChartView *chartViewone ;
     LineChartDataSet *set1;
    LineChartData *PartOnedata;
    
    NSMutableArray *PID1dataSource;
    NSInteger PID1indextag;
    NSDate *VssUpbeforeDate;
    NSDate *VssUpafterDate;
    BOOL isVssUpStart;
    NSDate *VssDownbeforeDate;
    NSDate *VssDownafterDate;
    BOOL isVssDownStart;
    BOOL isVssDowncountStart;
    NSDate *Distance100Date;
    BOOL isDistance100Start;
    BOOL isDistance100End;
    CGFloat DownDistance;
    CGFloat TotalDistance;
    NSDate  *StartTime;
    NSDate   *preDate;
    NSDate *adate;
    NSInteger GetDataCount;
    UILabel *totalTimeLabel;
    UILabel *totalDistanceLabel;
    DashboardViewStyleB *dashViewB;
    reportModel *reportmodel;
}
@end

@implementation PerformancesViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Performance" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self initWithData];
     [self initWithUI];
}
- (void)initWithData{
    set1 = nil;
    isVssUpStart = NO;
    isVssDownStart = NO;
    isVssDowncountStart = YES;
    PartOnedata = [[LineChartData alloc] initWithDataSet:set1];
    PID1dataSource = [[NSMutableArray alloc]init];
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    DownDistance = 0;
    TotalDistance = 0;
    GetDataCount = 0;
    isDistance100Start = YES;
    isDistance100End = YES;
    reportmodel = [[reportModel alloc]init];
}
- (NSMutableAttributedString *)setAttributed:(NSString *)String withRange:(NSInteger)range{
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc]initWithString:String];
    NSRange theRange = NSMakeRange(range, resultStr.length - range);
    [resultStr addAttribute:NSForegroundColorAttributeName value:[ColorTools colorWithHexString:@"C8C6C6"] range:theRange];
    return resultStr;
}
- (void)initWithUI{
        totalTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TopHigh, MSWidth/2, 25)];
         totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [totalTimeLabel setTextColor:[ColorTools colorWithHexString:@"FE9002"]];
        totalTimeLabel.adjustsFontSizeToFitWidth = YES;
         [totalTimeLabel setAttributedText:[self setAttributed:@"Time:00:00:00" withRange:5]];
         [self.view addSubview:totalTimeLabel];
        
        totalDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake((MSWidth/2)+15, TopHigh, MSWidth/2, 25)];
    totalDistanceLabel.adjustsFontSizeToFitWidth = YES;
    [totalDistanceLabel setTextColor:[ColorTools colorWithHexString:@"FE9002"]];
        totalDistanceLabel.textAlignment = NSTextAlignmentCenter;
        [totalDistanceLabel setAttributedText:[self setAttributed:@"Distance:0m" withRange:9]];
        [self.view addSubview:totalDistanceLabel];
  
    [self initWithDataUI ];

    startBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, MSHeight -110 , 100, 40)];
    [startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [startBtn setTitleColor:[ColorTools colorWithHexString:@"101010"] forState:UIControlStateNormal];
    startBtn.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    startBtn.layer.cornerRadius = 5.f;
    [startBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSWidth-100- 20, MSHeight -110  , 100, 40)];
    [reportBtn setTitle:@"Report" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[ColorTools colorWithHexString:@"101010"] forState:UIControlStateNormal];
    reportBtn.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    reportBtn.layer.cornerRadius = 5.f;
      [reportBtn addTarget:self action:@selector(reportBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [self.view addSubview:reportBtn];
    
}
- (void)initWithDataUI{
    if (IS_IPHONE_4_OR_LESS) {
    dashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake((MSWidth-160*Kwidthmultiple)/2,TopHigh+35 , 160*Kwidthmultiple, 160*Kwidthmultiple)];
    }else{
     dashViewB = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake((MSWidth-250*Kwidthmultiple)/2,TopHigh+35 , 250*Kwidthmultiple, 250*Kwidthmultiple)];
    }
    DashboardB *model = [DashboardB new];
    [self initWithModel:model];
    [dashViewB initWithModel:model];
    dashViewB.PIDLabel.text = @"speed";
    dashViewB.NumberLabel.text = @"0";
    [self.view addSubview:dashViewB];
   if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
         chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dashViewB.frame)+5, MSWidth, 170)];
    }else{
         chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dashViewB.frame)+5, MSWidth, 230*KHeightmultiple)];
    }
   
    [self initWithchartView:chartViewone ];
    [self.view addSubview:chartViewone];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"Speed" withLineColor:[ColorTools colorWithHexString:@"FFFF00"] withDependency:AxisDependencyLeft iSsmoothing:YES];
}
-(void)initWithModel:(DashboardB *)model{
    model.ValueColor  = @"#FFFFFF";
    model.ValueFontScale = [NSNumber numberWithFloat:1.f];
    model.ValuePositon = [NSNumber numberWithFloat:1.f];
    model.ValueVisible = YES;
    model.titleColor  = @"#757476";
    model.titleFontScale = [NSNumber numberWithFloat:1.f];
    model.titlePositon = [NSNumber numberWithFloat:1.f];
    
    model.UnitColor = @"#757476";
    model.UnitFontScale = [NSNumber numberWithFloat:1.f];
    model.UnitPositon = [NSNumber numberWithFloat:1.f];
    
    
    model.backColor = @"00a6ff";
    model.GradientRadius = [NSNumber numberWithFloat:MSWidth/2];
    
    model.FillColor = @"FE9002";
    model.FillEnable = YES;
    
    model.Pointerwidth = [NSNumber numberWithFloat:1.f];
//    model.pointerColor = @"#FFFFFF";
}
- (void)back{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"停止停止");
        [self stopSend];
    });
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (void)rightBarButtonClick{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"停止停止");
        [self stopSend];
    });
    PerformanceSetController *vc =  [[PerformanceSetController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)stopSend{
    NSLog(@"停止停止");
    self.blueTooth.stopSend = YES;
}
-(void)reportBtn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"停止停止");
        [self stopSend];
    });
    PropertyReportController *vc = [[PropertyReportController alloc]init];
    NSLog(@"模型模型%@",reportmodel.reportUp100Time);
    vc.model = reportmodel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)startBtn{
//     [self initWithData];
    //发送车速
    [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
    NSDate *currentDate = [NSDate date]; // 当前日期
    StartTime = currentDate;
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
    NSLog(@"%@",VehicleSpeedStr);
    if (!(VehicleSpeedStr == nil)) {
        NSDate *nowDate = [NSDate date]; // 当前日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
        NSTimeInterval delta = [nowDate timeIntervalSinceDate:StartTime]; // 计算出相差多少秒
        [self showTotalTime:delta]; //计算性能测试开始的时间
        dashViewB.NumberLabel.text = VehicleSpeedStr ;
        [PID1dataSource addObject:VehicleSpeedStr];
        [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:(int)PID1indextag  withY:[PID1dataSource[PID1indextag] intValue]];
        ++PID1indextag;
         NSInteger index = PID1indextag;
        if (GetDataCount == 0) {
            double space = [VehicleSpeedStr doubleValue]/(3.6);
            TotalDistance = delta*space;
            reportmodel.reportMaxSpeed = VehicleSpeedStr;
        [self showTotalDiatance:TotalDistance]; //计算性能测试开始的距离
            preDate = nowDate;
            ++GetDataCount;
        }else{
            //取得最大车速
            if ([VehicleSpeedStr doubleValue] > [reportmodel.reportMaxSpeed doubleValue]) {
                reportmodel.reportMaxSpeed = VehicleSpeedStr;
            }
            NSInteger indextag = PID1indextag;
            NSTimeInterval delta = [nowDate timeIntervalSinceDate:preDate]; // 计算出相差多少秒
            double space = ([PID1dataSource[--indextag] doubleValue]+[PID1dataSource[--indextag] doubleValue])/(2*3.6);
            TotalDistance = TotalDistance +space*delta;
            [self showTotalDiatance:TotalDistance]; //计算性能测试开始的距离
            preDate = nowDate;
        }
        //计算0-100m的时间
        if (TotalDistance >0) {
            if (isDistance100Start == YES) {
                Distance100Date = preDate;
                isDistance100Start = NO;
            }
            if (TotalDistance >= 100 && isDistance100End == YES) {
               NSTimeInterval delta = [nowDate timeIntervalSinceDate:Distance100Date]; // 计算出相差多少秒
                [self showTime:delta];
                isDistance100End = NO;
            }
        }
        if ([VehicleSpeedStr isEqualToString:@"0"]) {
            isVssUpStart = YES;
            VssUpbeforeDate = [NSDate date]; // 当前日期
            if (isVssDownStart == YES) {
                VssDownafterDate =  [NSDate date]; // 当前日期
                NSTimeInterval delta = [VssDownafterDate timeIntervalSinceDate:VssDownbeforeDate]; // 计算出相差多少秒
                double space = ([PID1dataSource[--index] doubleValue]+[PID1dataSource[--index] doubleValue])/(2*3.6);
                DownDistance = DownDistance +space*delta;
                  [self showDown:DownDistance];
                isVssDownStart = NO;
                isVssDowncountStart = YES;
                DownDistance = 0;
            }            
        }
    if ([VehicleSpeedStr integerValue]>0) {
        if ([VehicleSpeedStr integerValue] >= 100) {
           VssUpafterDate =  [NSDate date]; // 当前日期
            NSTimeInterval delta = [VssUpafterDate timeIntervalSinceDate:VssUpbeforeDate]; // 计算出相差多少秒
            if (isVssUpStart==YES) {
                [self showjiasu:delta];
                isVssUpStart = NO;
            }
            //刹车速度大于100
            isVssDownStart = YES;
            isVssDowncountStart = YES;
        }else{ //刹车速度小于100
            if(isVssDownStart == YES){
                NSInteger sendCount = 0;
                if (isVssDowncountStart == YES) {//第一次得到100的速度就记录，之后就不记录
                VssDownbeforeDate =  [NSDate date]; // 当前日期
                isVssDowncountStart = NO;
                 sendCount    = 1;
                    DownDistance = 0;
                }
                
                if (sendCount == 1) {
                    adate = [NSDate date];
                }else{
                    NSDate *currentData =  [NSDate date]; // 当前日期
                    NSTimeInterval delta = [currentData timeIntervalSinceDate:adate]; // 计算出相差多少秒
                    double space = ([PID1dataSource[--index] doubleValue]+[PID1dataSource[--index] doubleValue])/(2*3.6);
                    DownDistance = DownDistance +space*delta;
                    adate = currentData;
                }
            }
        }
        
    }
        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];

    }
    
}
-(void)BlueToothState:(BlueToothState)state{
    
}
-(void)showTotalTime:(CGFloat)totalTime{
    NSLog(@"时间时间%f",totalTime);
    [totalTimeLabel setAttributedText:[self setAttributed:[NSString stringWithFormat:@"Time:%.2f",totalTime] withRange:5]];
    reportmodel.reportRunTime = [NSString stringWithFormat:@"%.2f",totalTime];
}
- (void)showTotalDiatance:(CGFloat)totalDiatance{
  [totalDistanceLabel setAttributedText:[self setAttributed:[NSString stringWithFormat:@"Distance:%.2f",totalDiatance] withRange:9]];
}
- (void)showjiasu:(CGFloat)number{
    reportmodel.reportSpeedUpTime = [NSString stringWithFormat:@"%.2fs",number];
}
- (void)showDown:(CGFloat)number{
    reportmodel.reportSpeedDownDistance = [NSString stringWithFormat:@"%.2fm",number];
}
- (void)showTime:(CGFloat)number{
    reportmodel.reportUp100Time =[NSString stringWithFormat:@"%.2fs",number];
}
- (void)initWithchartView:(LineChartView *)view {
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
    [leftAxis resetCustomAxisMax];
    [leftAxis resetCustomAxisMin];
    //    leftAxis.axisMaximum = 200.0;
    //    leftAxis.axisMinimum = 0.0;
    leftAxis.drawAxisLineEnabled = YES;
    // 设置右边的Y轴
    
    ChartYAxis *rightAxis = view.rightAxis;
    rightAxis.labelTextColor = [UIColor clearColor];
//    //    rightAxis.axisMaximum = 900.0;
//    //    rightAxis.axisMinimum = -200.0;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = YES;
    rightAxis.axisLineWidth = 2;
        [leftAxis setAxisLineColor:[ColorTools colorWithHexString:@"FFFF00"]];
        [rightAxis setAxisLineColor: [UIColor clearColor]];
    leftAxis.axisLineWidth = 2;
    leftAxis.labelCount = 5;
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

@end
