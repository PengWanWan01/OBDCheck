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
    CGFloat DownDistance;
    UIButton *UpBtn;
    UIButton *DownBtn;
    UIButton *TimeBtn;
    NSDate *adate;
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
    DownDistance = 0;
}
- (void)initWithUI{
     chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 250)];
    [self initWithchartView:chartViewone ];
    [self.view addSubview:chartViewone];
    [self setDataCount:0 range:0 withView:chartViewone withdata:PartOnedata withPIDTiltle:@"Speed" withLineColor:[ColorTools colorWithHexString:@"FFFF00"] withDependency:AxisDependencyLeft iSsmoothing:YES];
    UpBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame)+10, MSWidth, 20)];
     DownBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(UpBtn.frame)+10, MSWidth, 20)];
     TimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(DownBtn.frame)+10, MSWidth, 20)];
    [UpBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
     [DownBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
     [TimeBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
    [UpBtn setTitle:@"0-100KM/H:" forState:UIControlStateNormal];
    [DownBtn setTitle:@"100-0KM/H:" forState:UIControlStateNormal];
    [TimeBtn setTitle:@"0-100M:" forState:UIControlStateNormal];

    [self.view addSubview:UpBtn];
    [self.view addSubview:DownBtn];
    [self.view addSubview:TimeBtn];

    startBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, MSHeight -TopHigh -100 , 100, 40)];
    [startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [startBtn setTitleColor:[ColorTools colorWithHexString:@"101010"] forState:UIControlStateNormal];
    startBtn.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    [startBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSWidth-100- 20, MSHeight -TopHigh-100 , 100, 40)];
    [reportBtn setTitle:@"Report" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[ColorTools colorWithHexString:@"101010"] forState:UIControlStateNormal];
    reportBtn.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
      [reportBtn addTarget:self action:@selector(reportBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [self.view addSubview:reportBtn];
    
}
- (void)back{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"停止停止");
        [self stopSend];
    });
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
}
- (void)stopSend{
    NSLog(@"停止停止");
    //发送ATDP指令；
    [self.blueTooth SendData:[BlueTool hexToBytes:@"415444500D"]];
}
-(void)reportBtn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"停止停止");
        [self stopSend];
    });
    PropertyReportController *vc = [[PropertyReportController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)startBtn{
    //发送车速
    [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];

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
//        NSDate *nowDate = [NSDate date]; // 当前日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
//        NSDate *creat = [formatter dateFromString:(任意时间)];// 将传入的字符串转化成时间
//        NSTimeInterval delta = [nowDate timeIntervalSinceDate:creat]; // 计算出相差多少秒

        [PID1dataSource addObject:VehicleSpeedStr];
//        NSLog(@"数据%@",PID1dataSource);
        [self updateChartData:chartViewone withData:PartOnedata withIndex:0 withX:(int)PID1indextag  withY:[PID1dataSource[PID1indextag] intValue]];
        ++PID1indextag;
         NSInteger index = PID1indextag;
//        NSLog(@"速度%@",VehicleSpeedStr);
        if ([VehicleSpeedStr isEqualToString:@"0"]) {
            isVssUpStart = YES;
            VssUpbeforeDate = [NSDate date]; // 当前日期
            if (isVssDownStart == YES) {
                VssDownafterDate =  [NSDate date]; // 当前日期
                NSTimeInterval delta = [VssDownafterDate timeIntervalSinceDate:VssDownbeforeDate]; // 计算出相差多少秒
//                NSLog(@"刹车时间差%f",delta);
//                NSLog(@"%@",PID1dataSource);
//                NSLog(@"速度%f--%f",[PID1dataSource[--index] doubleValue],[PID1dataSource[--index] doubleValue] );
                double space = ([PID1dataSource[--index] doubleValue]+[PID1dataSource[--index] doubleValue])/(2*3.6);
                DownDistance = DownDistance +space*delta;
//                NSLog(@"路程%f",DownDistance);
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
//                 NSLog(@"时间差%f",delta);
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
//                NSLog(@"计刹车时间开始");
                isVssDowncountStart = NO;
                 sendCount    = 1;
                    DownDistance = 0;
                }
                
                if (sendCount == 1) {
                    adate = [NSDate date];
                }else{
                    NSDate *currentData =  [NSDate date]; // 当前日期
                    NSTimeInterval delta = [currentData timeIntervalSinceDate:adate]; // 计算出相差多少秒
//                    NSLog(@"两个时间间隔%f",delta);
//                    NSLog(@"个数%ld",(long)index);
                    double space = ([PID1dataSource[--index] doubleValue]+[PID1dataSource[--index] doubleValue])/(2*3.6);
                    DownDistance = DownDistance +space*delta;
//                    NSLog(@"路程%f",DownDistance);
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
- (void)showjiasu:(CGFloat)number{
    [UpBtn setTitle:[NSString stringWithFormat:@"0-100KM/H  :%fs",number] forState:UIControlStateNormal];
}
- (void)showDown:(CGFloat)number{
    [DownBtn setTitle:[NSString stringWithFormat:@"100-0KM/H  :%fm",number] forState:UIControlStateNormal];
}
- (void)showTime:(CGFloat)number{
    [TimeBtn setTitle:[NSString stringWithFormat:@"0-100m  :%fs",number] forState:UIControlStateNormal];
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
