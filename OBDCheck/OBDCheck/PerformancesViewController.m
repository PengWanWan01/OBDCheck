//
//  PerformancesViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformancesViewController.h"

@interface PerformancesViewController ()<ChartViewDelegate,BlueToothControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton *startBtn;
    UIButton *reportBtn;
    
    UILabel *vehicleLabel;
    UILabel *rotateLabel;
    UILabel *vehicleUnitLabel;
    UILabel *rotateUnitLabel;
    UIBezierPath *vehicleCirclePath;
    UIBezierPath *rotateCirclePath;
    UIView *circleView;
    UIView *headView;
    NSMutableArray *PID1dataSource;
    NSInteger PID1indextag;
    NSDate *VssUpbeforeDate;
    NSDate *VssUpafterDate;
    BOOL isVssUpStart;
    NSDate *VssDownbeforeDate;
    NSDate *VssDownafterDate;
    BOOL isVssDownStart;
    BOOL isVssDowncountStart;
    NSDate *DistanceTestDate;
    BOOL isDistanceTestStart;
    BOOL isDistanceTestEnd;
    CGFloat DownDistance;
    CGFloat TotalDistance;
    NSDate  *StartTime;
    NSDate   *preDate;
    NSDate *adate;
    NSInteger GetDataCount;
    UILabel *totalTimeLabel;
    UILabel *totalDistanceLabel;
//    DashboardViewStyleB *dashViewB;
    reportModel *reportmodel;
    UIView *lineView ;
    CGFloat AcceleratedStartSpeed;
    CGFloat AcceleratedEndSpeed;
    CGFloat BrakingSpeed;
    CGFloat DistanceTest;
}
@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *dataSource;
@property (nonatomic,strong) NSMutableArray  *detialDataSource;

@end

@implementation PerformancesViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Performance" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self initWithData];
     [self initWithUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)viewTapped
{
    
    [self.view endEditing:YES];

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
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight-50);
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
    if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
    }else{
        DLog(@"竖屏");
        [self setVerticalFrame];
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
      headView.frame =CGRectMake(0, 0, MSWidth, 60+130+ (SCREEN_MIN-110)/2);
     totalTimeLabel.frame = CGRectMake(0, 15, SCREEN_MIN/2, 25);
    vehicleLabel.frame = CGRectMake(35, (SCREEN_MIN-100)/4+CGRectGetMaxY(totalTimeLabel.frame) , (SCREEN_MIN-100)/2, 30);
    rotateLabel.frame =CGRectMake(35+(SCREEN_MIN-100)/2 + 30, (SCREEN_MIN-100)/4+CGRectGetMaxY(totalTimeLabel.frame) , (SCREEN_MIN-100)/2, 30);
    [self initWithVerticalCircleUI];
    vehicleUnitLabel.frame = CGRectMake(35, (SCREEN_MIN-100)/4+CGRectGetMaxY(totalTimeLabel.frame)+30, (SCREEN_MIN-100)/2, 30 );
      rotateUnitLabel.frame = CGRectMake(35+((SCREEN_MIN-100)/2 + 30), (SCREEN_MIN-100)/4+CGRectGetMaxY(totalTimeLabel.frame)+30, (SCREEN_MIN-100)/2, 30 );
    
      startBtn.frame = CGRectMake(40, (SCREEN_MIN-30)/4+CGRectGetMaxY(totalTimeLabel.frame) + 120 , (SCREEN_MIN-110)/2, 40);
      reportBtn.frame = CGRectMake((SCREEN_MIN-110)/2 +75, (SCREEN_MIN-30)/4+CGRectGetMaxY(totalTimeLabel.frame) + 120  , (SCREEN_MIN-110)/2, 40);
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    headView.frame =CGRectMake(0, 0, SCREEN_MAX, 80+40+ (SCREEN_MIN-110)/2+20);
    totalTimeLabel.frame = CGRectMake(0, 15, SCREEN_MAX/2, 25);
  vehicleLabel.frame = CGRectMake(100, CGRectGetMaxY(totalTimeLabel.frame)+(SCREEN_MIN-100)/4 , (SCREEN_MIN-100)/2, 30);
   rotateLabel.frame =CGRectMake(SCREEN_MAX-100-(SCREEN_MIN-100)/2, CGRectGetMaxY(totalTimeLabel.frame)+(SCREEN_MIN-100)/4 ,  (SCREEN_MIN-100)/2, 30);
    [self initWithHorizontalCircleUI];

    vehicleUnitLabel.frame = CGRectMake(100, CGRectGetMaxY(vehicleLabel.frame), (SCREEN_MIN-100)/2, 30 );
    rotateUnitLabel.frame = CGRectMake(SCREEN_MAX-100-(SCREEN_MIN-100)/2, CGRectGetMaxY(rotateLabel.frame), (SCREEN_MIN-100)/2, 30 );
     startBtn.frame = CGRectMake(100, (SCREEN_MIN-30)/4+CGRectGetMaxY(totalTimeLabel.frame) + 80 , (SCREEN_MIN-110)/2, 40);
      reportBtn.frame = CGRectMake(SCREEN_MAX-100-(SCREEN_MIN-110)/2,(SCREEN_MIN-30)/4+CGRectGetMaxY(totalTimeLabel.frame) + 80  , (SCREEN_MIN-110)/2, 40);
}
#pragma mark 竖屏的圆圈
- (void)initWithVerticalCircleUI{
    [circleView removeFromSuperview];
    circleView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(totalTimeLabel.frame) + 20, SCREEN_MAX, (SCREEN_MIN-100)/2)];
//    circleView.backgroundColor = [UIColor redColor];
    [headView addSubview:circleView];
    //画圆圈
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
    //    CALayer *containerLayer = [CALayer layer];
    for (NSInteger i = 0 ; i<2; i++) {
        // 环形Layer层
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.lineWidth = 5.f;
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin = kCALineJoinRound;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *CircelPath =[UIBezierPath bezierPathWithArcCenter:CGPointMake(35+(SCREEN_MIN-100)/4+((SCREEN_MIN-100)/2 + 30)*i, circleView.frame.size.height/2) radius:(SCREEN_MIN-100)/4 startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        circleLayer.path = CircelPath.CGPath;
        [circleView.layer addSublayer:circleLayer];
        if (i ==0) {
            circleLayer.strokeColor = [ColorTools colorWithHexString:@"FE9002"].CGColor;
        }else{
            circleLayer.strokeColor = [UIColor blackColor].CGColor;
        }
    }
}
#pragma mark 横屏的圆圈
- (void)initWithHorizontalCircleUI{
    [circleView removeFromSuperview];
    circleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(totalTimeLabel.frame) + 20, SCREEN_MAX, (SCREEN_MIN-100)/2)];
//    circleView.backgroundColor = [UIColor redColor];
    [headView addSubview:circleView];
    //画圆圈
    CGFloat startAngle = 0; // 开始角度
    CGFloat endAngle = 2*M_PI; // 结束角度
    BOOL clockwise = YES; // 顺时针
    //    CALayer *containerLayer = [CALayer layer];
    for (NSInteger i = 0 ; i<2; i++) {
        // 环形Layer层
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.lineWidth = 5.f;
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin = kCALineJoinRound;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *CircelPath =[UIBezierPath bezierPathWithArcCenter:CGPointMake(100+(SCREEN_MIN-100)/4+(SCREEN_MAX-(SCREEN_MIN-100)/2-200)*i,circleView.frame.size.height/2) radius:(SCREEN_MIN-100)/4 startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        circleLayer.path = CircelPath.CGPath;
        [circleView.layer addSublayer:circleLayer];
        if (i ==0) {
            circleLayer.strokeColor = [ColorTools colorWithHexString:@"FE9002"].CGColor;
        }else{
            circleLayer.strokeColor = [UIColor blackColor].CGColor;
        }
        
    }
}
- (void)initWithData{
 
    isVssUpStart = NO;
    isVssDownStart = NO;
    isVssDowncountStart = YES;
    PID1dataSource = [[NSMutableArray alloc]init];
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    DownDistance = 0;
    TotalDistance = 0;
    GetDataCount = 0;
    isDistanceTestStart = YES;
    isDistanceTestEnd = YES;
    reportmodel = [[reportModel alloc]init];
    self.dataSource = [[NSMutableArray alloc]init];
    self.detialDataSource = [[NSMutableArray alloc]init];
    AcceleratedStartSpeed = 0;
    AcceleratedEndSpeed = 100;
    BrakingSpeed = 100;
    DistanceTest = 100;
}

- (NSMutableAttributedString *)setAttributed:(NSString *)String withRange:(NSInteger)range{
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc]initWithString:String];
    NSRange theRange = NSMakeRange(range, resultStr.length - range);
    [resultStr addAttribute:NSForegroundColorAttributeName value:[ColorTools colorWithHexString:@"C8C6C6"] range:theRange];
    return resultStr;
}
- (void)initWithUI{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 80+130+ (SCREEN_MIN-110)/2)];
//    headView.backgroundColor = [UIColor goldColor];
    [self.view addSubview:headView];
        totalTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TopHigh, MSWidth/2, 25)];
         totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [totalTimeLabel setTextColor:[ColorTools colorWithHexString:@"FE9002"]];
        totalTimeLabel.adjustsFontSizeToFitWidth = YES;
         [totalTimeLabel setAttributedText:[self setAttributed:@"Time:00:00:00" withRange:5]];
         [headView addSubview:totalTimeLabel];
        
//        totalDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake((MSWidth/2)+15, TopHigh, MSWidth/2, 25)];
//    totalDistanceLabel.adjustsFontSizeToFitWidth = YES;
//    [totalDistanceLabel setTextColor:[ColorTools colorWithHexString:@"FE9002"]];
//        totalDistanceLabel.textAlignment = NSTextAlignmentCenter;
//        [totalDistanceLabel setAttributedText:[self setAttributed:@"Distance:0m" withRange:9]];
//        [self.view addSubview:totalDistanceLabel];
  
    [self initWithDataUI ];

    startBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, (MSWidth-30)/4+CGRectGetMaxY(totalTimeLabel.frame) + 120 , (MSWidth-110)/2, 40)];
    [startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [startBtn setTitleColor:[ColorTools colorWithHexString:@"101010"] forState:UIControlStateNormal];
    startBtn.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    startBtn.layer.cornerRadius = 5.f;
    [startBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    reportBtn = [[UIButton alloc]initWithFrame:CGRectMake((MSWidth-110)/2 +75, (MSWidth-30)/4+CGRectGetMaxY(totalTimeLabel.frame) + 120  , (MSWidth-110)/2, 40)];
    [reportBtn setTitle:@"Report" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[ColorTools colorWithHexString:@"101010"] forState:UIControlStateNormal];
    reportBtn.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    reportBtn.layer.cornerRadius = 5.f;
    [reportBtn addTarget:self action:@selector(reportBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:startBtn];
    [headView addSubview:reportBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-50) style:UITableViewStylePlain];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Speed up the test range",@"Braking Speed",@"Distance test", nil];
    self.detialDataSource = [[NSMutableArray alloc]initWithObjects:@"0 -100  km/h",@"100 m",@"100 m", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = headView;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:self.tableView];
    
}

- (void)initWithDataUI{
  
    for (NSInteger i = 0 ; i<2; i++) {
   
        if (i ==0) {
          vehicleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, (MSWidth-100)/4+CGRectGetMaxY(totalTimeLabel.frame) , (MSWidth-100)/2, 30)];
            vehicleLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            vehicleLabel.text = @"000";
            //        vehicleLabel.backgroundColor = [UIColor redColor];
            vehicleLabel.textAlignment = NSTextAlignmentCenter;
            vehicleLabel.font = [UIFont systemFontOfSize:30.f];
            [headView addSubview:vehicleLabel];
             vehicleUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, (MSWidth-100)/4+CGRectGetMaxY(totalTimeLabel.frame)+30, (MSWidth-100)/2, 30 )];
            vehicleUnitLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
            vehicleUnitLabel.font = [UIFont systemFontOfSize:16.f];
            vehicleUnitLabel.textAlignment = NSTextAlignmentCenter;
            vehicleUnitLabel.text=  @"km/h";
              [headView addSubview:vehicleUnitLabel];
        }else{
            rotateLabel =[[UILabel alloc]initWithFrame:CGRectMake(35+(MSWidth-100)/2 + 30, (MSWidth-100)/4+CGRectGetMaxY(totalTimeLabel.frame) , (MSWidth-100)/2, 30)];
            rotateLabel.text = @"000";
            //        rotateLabel.backgroundColor = [UIColor redColor];
            rotateLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            rotateLabel.textAlignment = NSTextAlignmentCenter;
            rotateLabel.font = [UIFont systemFontOfSize:30.f];
            [headView addSubview:rotateLabel];
             rotateUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(35+((MSWidth-100)/2 + 30), (MSWidth-100)/4+CGRectGetMaxY(totalTimeLabel.frame)+30, (MSWidth-100)/2, 30 )];
            rotateUnitLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
            rotateUnitLabel.font = [UIFont systemFontOfSize:16.f];
            rotateUnitLabel.textAlignment = NSTextAlignmentCenter;
            rotateUnitLabel.text=  @"r/min";
            [headView addSubview:rotateUnitLabel];
        }
      
    }
   
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, MSWidth-20, 34)];
    lable.text = @"Test Range";
    lable.textColor = [ColorTools colorWithHexString:@"FE9002"];
   [headView addSubview:lable];
    return headView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.text = self.dataSource[indexPath.row];
//    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
//    cell.detailTextLabel.text = self.detialDataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(200, 0, 150, 44)];
        UITextField *StartTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        StartTextFiled.tag = indexPath.row;
        StartTextFiled.text = [NSString stringWithFormat:@"%.f",AcceleratedStartSpeed];
        StartTextFiled.textColor = [UIColor whiteColor];
        StartTextFiled.textAlignment = NSTextAlignmentCenter;
        StartTextFiled.delegate = self;
        StartTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        [StartTextFiled addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        [view addSubview:StartTextFiled];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 10, 44)];
        lineLabel.textColor = [UIColor whiteColor];
        lineLabel.text = @"-";
        lineLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lineLabel];
        UITextField *EndTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 0, 50, 44)];
        EndTextFiled.tag = indexPath.row + 1;
        EndTextFiled.text = [NSString stringWithFormat:@"%.f",AcceleratedEndSpeed];
        StartTextFiled.tag = 1;
        EndTextFiled.textColor = [UIColor whiteColor];
        EndTextFiled.textAlignment = NSTextAlignmentCenter;
        EndTextFiled.delegate = self;
        EndTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        [EndTextFiled addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        [view addSubview:EndTextFiled];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 40, 44)];
        label.text =  @"km/h";
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        
          cell.accessoryView = view;
    }else{
        UITextField *distanceTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(200, 0, 100, 44)];
        distanceTextFiled.tag = indexPath.row + 1;
        if (indexPath.row == 1) {
            distanceTextFiled.text = [NSString stringWithFormat:@"%.fm",BrakingSpeed];
        }else{
           distanceTextFiled.text =  [NSString stringWithFormat:@"%.fm",DistanceTest];
        }
        distanceTextFiled.textColor = [UIColor whiteColor];
        distanceTextFiled.textAlignment = NSTextAlignmentRight;
        distanceTextFiled.delegate = self;
        distanceTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        [distanceTextFiled addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.accessoryView = distanceTextFiled;
    }
    return cell;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            {
                DLog(@"开始时间");
            }
            break;
        case 1:
        {
            DLog(@"结束时间");
        }
            break;
        case 2:
        {
            DLog(@"刹车时间");
        }
            break;
        case 3:
        {
            DLog(@"开始时间");
        }
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)back{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DLog(@"停止停止");
        [self stopSend];
    });
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    
}
//- (void)rightBarButtonClick{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        DLog(@"停止停止");
//        [self stopSend];
//    });
//    PerformanceSetController *vc =  [[PerformanceSetController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
- (void)stopSend{
    DLog(@"停止停止");
    self.blueTooth.stopSend = YES;
}
-(void)reportBtn{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DLog(@"停止停止");
        [self stopSend];
    });
    PropertyReportController *vc = [[PropertyReportController alloc]init];
    DLog(@"模型模型%@",reportmodel.reportUp100Time);
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
    DLog(@"收到收到%@",data);
    
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DLog(@"最后的数据%@,数据长度%ld",string,(unsigned long)string.length);
    NSString *VehicleSpeedStr = [BlueTool isVehicleSpeed:string];
   NSString *RotationalStr = [BlueTool isRotational:string];
    DLog(@"%@",VehicleSpeedStr);
    if (!(VehicleSpeedStr == nil)) {
        vehicleLabel.text = VehicleSpeedStr;
        //得到车速之后，发送转速
        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130630D"]];
        NSDate *nowDate = [NSDate date]; // 当前日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
        NSTimeInterval delta = [nowDate timeIntervalSinceDate:StartTime]; // 计算出相差多少秒
        [self showTotalTime:delta]; //计算性能测试开始的时间
        rotateLabel.text = VehicleSpeedStr ;
        [PID1dataSource addObject:VehicleSpeedStr];
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
        
 //计算设置的结束距离，0-例如：100m（结束距离） 的时间
        if (TotalDistance > 0) {
            if (isDistanceTestStart == YES) {
                DistanceTestDate = preDate;
                isDistanceTestStart = NO;
            }
            if (TotalDistance >= DistanceTest && isDistanceTestEnd == YES) {
               NSTimeInterval delta = [nowDate timeIntervalSinceDate:DistanceTestDate]; // 计算出相差多少秒
                [self showTime:delta];
                isDistanceTestEnd = NO;
            }
        }
//计算加速度的开始速度到结束速度的加速度
        if ([VehicleSpeedStr doubleValue] == AcceleratedStartSpeed) {
            isVssUpStart = YES;
            VssUpbeforeDate = [NSDate date]; // 当前日期
        }
        if ([VehicleSpeedStr integerValue]>0) {
            if ([VehicleSpeedStr doubleValue] >= AcceleratedEndSpeed) {
                VssUpafterDate =  [NSDate date]; // 当前日期
                NSTimeInterval delta = [VssUpafterDate timeIntervalSinceDate:VssUpbeforeDate]; // 计算出相差多少秒
                if (isVssUpStart==YES) {
                    [self showjiasu:delta];
                    isVssUpStart = NO;
                }
            }
        }
        
    
        
//计算刹车的结束速度 到0的 刹车距离与时间
        if ([VehicleSpeedStr isEqualToString:@"0"]) {
            if (isVssDownStart == YES) {
                VssDownafterDate =  [NSDate date]; // 当前日期
                NSTimeInterval delta = [VssDownafterDate timeIntervalSinceDate:VssDownbeforeDate]; // 计算出相差多少秒
                double space = ([PID1dataSource[--index] doubleValue]+[PID1dataSource[--index] doubleValue])/(2*3.6);
                DownDistance = DownDistance +space*delta;
                  [self showDownDistance:DownDistance];
                isVssDownStart = NO;
                isVssDowncountStart = YES;
                DownDistance = 0;
            }            
        }
    if ([VehicleSpeedStr integerValue]>0) {
        if ([VehicleSpeedStr doubleValue] >= BrakingSpeed) {
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
        
        
    }
    if (!(RotationalStr == nil)) {
      [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
        rotateLabel.text = RotationalStr;
    }
}
-(void)BlueToothState:(BlueToothState)state{
    
}
-(void)showTotalTime:(CGFloat)totalTime{
    DLog(@"时间时间%f",totalTime);
    [totalTimeLabel setAttributedText:[self setAttributed:[NSString stringWithFormat:@"Time:%.2f",totalTime] withRange:5]];
    reportmodel.reportRunTime = [NSString stringWithFormat:@"%.2f",totalTime];
}
- (void)showTotalDiatance:(CGFloat)totalDiatance{
  [totalDistanceLabel setAttributedText:[self setAttributed:[NSString stringWithFormat:@"Distance:%.2f",totalDiatance] withRange:9]];
}
- (void)showjiasu:(CGFloat)number{
    reportmodel.reportSpeedUpTime = [NSString stringWithFormat:@"%.2fs",number];
}
- (void)showDownDistance:(CGFloat)number{
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
    DLog(@"updateChartData%ld",(long)linechartdata.entryCount);
    
}

@end
