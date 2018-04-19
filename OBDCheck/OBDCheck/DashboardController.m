//
//  DashboardController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardController.h"
#import "UIViewController+NavBar.h"

//#define baseViewWidth  (SCREEN_MIN)/2 - 30
//#define baseViewHeight  baseViewWidth
static dispatch_source_t _timer;
@interface DashboardController ()<UIScrollViewDelegate,selectStyleDelegete,touchMoveDelegate,StyleBtouchMoveDelegate,StyleCtouchMoveDelegate,BlueToothControllerDelegate>
{
    
    editDashboardsView *editview;
    UIScrollView *scrollView;
    UIPageControl *pageControl ;
    DashboardView *dashboardStyleAView;
    DashboardViewStyleB *dashboardStyleBView;
    DashboardViewStyleC *dashboardStyleCView;
    CGFloat diameterPercent;
    CGFloat  LeftPercent;
    CGFloat  TopPercent;
    NSInteger DashBoardTag; //仪表的Tag标志
    UIView *coverView;  //遮盖层
    UILabel *contentLabel; //提示当前是有Label
    UIView *testView;
}
@property (nonatomic,strong) NSMutableArray *LabelNameArray;
@property (nonatomic,strong) NSMutableArray *numberArray;
@property (nonatomic,strong) NSMutableArray *CustomNumberArray;
@property (nonatomic,strong) NSMutableArray *CustomLabelArray;
@property (nonatomic,copy)  NSString *  PreNumberStr;
@end

@implementation DashboardController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self updateView];
    [self startAnimation];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
  
}
#pragma mark 设置横竖屏布局

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    [self initWithData];
//    DLog(@"000--%f",TopHigh);
    if (isLandscape) {
        //翻转为横屏时
        [self setHorizontalFrame];
    }else{
        //翻转为竖屏时
      
        [self setVerticalFrame];
    }
    DLog(@"旋转");
//    [self moveFoneView];
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    
    
    scrollView.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX);
    scrollView.contentSize = CGSizeMake(SCREEN_MIN*[DashboardSetting sharedInstance].KPageNumer,0);
    pageControl.frame = CGRectMake(0, SCREEN_MAX- self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -40, SCREEN_MIN, 30);
    if ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] == DashboardCustomMode) {
        NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK > 27"];
        for (CustomDashboard *dash in pAllCount) {
            switch (dash.dashboardType) {
                case 1:
                {
                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.pk ];
                    [dashboardStyleAView layoutSubviews];

//                    [dashboardStyleAView removeFromSuperview];
//                    dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.DashboardAorignx doubleValue], [dash.DashboardAorigny doubleValue], [dash.DashboardAorignwidth doubleValue], [dash.DashboardAorignheight doubleValue])];
//                    [self initWithCustomDashboardAFrame:dash];
//                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.pk ];
//                    dashboardStyleAView.frame = CGRectMake([dash.DashboardAorignx doubleValue],[dash.DashboardAorigny doubleValue], [dash.DashboardAorignwidth doubleValue], [dash.DashboardAorignheight doubleValue]);
//                    [dashboardStyleAView setNeedsLayout];
                }
                    break;
                case 2:
                {
                    [dashboardStyleBView layoutSubviews];
//                    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.pk ];
//                    dashboardStyleBView.frame = CGRectMake([dash.DashboardBorignx doubleValue],[dash.DashboardBorigny doubleValue], [dash.DashboardBorignwidth doubleValue], [dash.DashboardBorignheight doubleValue]);
//                    [dashboardStyleBView setNeedsLayout];
                }
                    break;
                case 3:
                {
                    [dashboardStyleCView layoutSubviews];

//                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.pk ];
//                    dashboardStyleCView.frame = CGRectMake([dash.DashboardCorignx doubleValue],[dash.DashboardCorigny doubleValue], [dash.DashboardCorignwidth doubleValue], [dash.DashboardCorignheight doubleValue]);
//                    [dashboardStyleCView setNeedsLayout];
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardStyle"]) {
            case DashboardStyleOne:
            {
                [self setVerticalDashboardFrame:DashboardStyleOne];
            }
                break;
            case DashboardStyleTwo:
            {
                [self setVerticalDashboardFrame:DashboardStyleTwo];
            }
                break;
            case DashboardStyleThree:
            {
                [self setVerticalDashboardFrame:DashboardStyleThree];
            }
                break;
            default:
                break;
        }
    }

}
#pragma mark 横屏
//风格一的仪表盘在controller中实现，通过移除先前的，再重建一个仪表盘
//风格二的仪表盘在 仪表盘View的自定义类中实现
//
- (void)setHorizontalFrame{
    scrollView.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN);
    scrollView.contentSize = CGSizeMake(SCREEN_MAX*[DashboardSetting sharedInstance].KPageNumer,0);
    pageControl.frame = CGRectMake(0, SCREEN_MIN- TopHigh -20, SCREEN_MAX, 30);
    
    if ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] == DashboardCustomMode) {
        NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK > 27"];
        for (CustomDashboard *dash in pAllCount) {
            switch (dash.dashboardType) {
                case 1:
                {
                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.pk ];
                    [dashboardStyleAView layoutSubviews];
                }
                    break;
                case 2:
                {
                    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.pk ];
                    [dashboardStyleBView setNeedsLayout];
                }
                    break;
                case 3:
                {
                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.pk ];
                    [dashboardStyleCView setNeedsLayout];
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }else{
        switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardStyle"]) {
            case DashboardStyleOne:
            {
                [self setHorizontalDashboardFrame:DashboardStyleOne];
            }
                break;
            case DashboardStyleTwo:
            {
                [self setHorizontalDashboardFrame:DashboardStyleTwo];
            }
                break;
            case DashboardStyleThree:
            {
                [self setHorizontalDashboardFrame:DashboardStyleThree];
            }
                break;
            default:
                break;
        }
    }
    
}
#pragma mark 设置横屏仪表盘Frame
- (void)setHorizontalDashboardFrame:(DashboardStyle)type {
    switch (type) {
        case DashboardStyleOne:
        {
          NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE  PK < 10"];
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.pk];
                [dashboardStyleAView layoutSubviews];
            }
        }
            break;
        case DashboardStyleTwo:
        {
            NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK >=10 and PK < 19"];
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.pk];
                [dashboardStyleBView layoutSubviews];
            }
        }
            break;
        case DashboardStyleThree:
        {
             NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK >=19 and PK < 28"];
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.pk];
                [dashboardStyleCView setNeedsLayout];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 设置竖屏仪表盘Frame
- (void)setVerticalDashboardFrame:(DashboardStyle)type {
    switch (type) {
        case DashboardStyleOne:
        {
            NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE  PK < 10"];
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.pk];
                [dashboardStyleAView layoutSubviews];
            }
        }
            break;
        case DashboardStyleTwo:
        {
            NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK >=10 and PK < 19"];
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.pk];
                [dashboardStyleBView layoutSubviews];
            }
        }
            break;
        case DashboardStyleThree:
        {
            NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK >=19 and PK < 28"];
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.pk];
                [dashboardStyleCView layoutSubviews];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark横竖屏之后调整Frame
-(void)initWithCustomDashboardAFrame:(CustomDashboard *)customDashboard{    
    dashboardStyleAView.tag = customDashboard.pk ;
    DashBoardTag = dashboardStyleAView.tag ;
    [dashboardStyleAView addGradientView:customDashboard.DashboardAouterColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
    dashboardStyleAView.delegate = self;
    if (!(customDashboard == nil)) {
        [dashboardStyleAView initWithModel:customDashboard];
    }
    dashboardStyleAView.infoLabel.text = _CustomLabelArray[customDashboard.pk  - 1-27];
    dashboardStyleAView.infoLabel.adjustsFontSizeToFitWidth = YES;
    dashboardStyleAView.numberLabel.text = _CustomNumberArray[customDashboard.pk  - 1-27];
    customDashboard.DashboardAinfoLabeltext = dashboardStyleAView.infoLabel.text;
    if ([customDashboard.DashboardAinfoLabeltext isEqualToString:@"RPM"]) {
        customDashboard.DashboardAmaxNumber = [NSString stringWithFormat:@"1000"] ;
    }
    [customDashboard update];
    [scrollView addSubview:dashboardStyleAView];
    [self MoveDashboard: dashboardStyleAView.tag];
}
-(void)initwithDashboardAFrame:(CustomDashboard *)dashboardA{
    dashboardStyleAView.tag = dashboardA.pk ;
    //画底盘渐变色
    [dashboardStyleAView addGradientView:dashboardA.DashboardAouterColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
    [dashboardStyleAView initWithModel:dashboardA];
    dashboardStyleAView.delegate = self;
    DashBoardTag = dashboardStyleAView.tag ;
    dashboardStyleAView.infoLabel.text = _LabelNameArray[dashboardStyleAView.tag - 1];
    dashboardStyleAView.infoLabel.adjustsFontSizeToFitWidth = YES;
    dashboardStyleAView.numberLabel.text = _numberArray[dashboardStyleAView.tag - 1];
    dashboardA.DashboardAinfoLabeltext = dashboardStyleAView.infoLabel.text;
    [dashboardA update];
    [scrollView addSubview:dashboardStyleAView];
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
- (void)viewDidLoad {
    
    [super viewDidLoad];
}
#pragma mark 遵守蓝牙的协议
-(void)BlueToothState:(BlueToothState)state{
    
}
-(void)getDeviceInfo:(BELInfo*)info{
    
}
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
//    DLog(@"收到数据%@",data);
//    NSString *number1 = _CustomNumberArray[0];
//    NSString *number2 = _CustomNumberArray[1];
//    NSString *number3 = _CustomNumberArray[2];
//    NSString *number4 = _CustomNumberArray[3];
//
//    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
////    DLog(@"%@",string);
//    NSString *VehicleSpeedStr = [BlueTool isVehicleSpeed:string];
//    NSString *RotationalStr = [BlueTool isRotational:string];
//    NSString *WatertemperatureStr = [BlueTool isWatertemperature:string];
//    NSString *ThrottlePositionStr = [BlueTool isThrottlePosition:string];
//    DLog(@"车速%@",VehicleSpeedStr);
//    DLog(@"转速%@",RotationalStr);
//    DLog(@"水温%@",WatertemperatureStr);
//    DLog(@"TF%@",ThrottlePositionStr);
//    
//    if (!(VehicleSpeedStr == nil)) {
//        
//        [_CustomNumberArray replaceObjectAtIndex:0 withObject:VehicleSpeedStr];
//        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"28",@"StyleAViewTag",_CustomNumberArray[0],@"StyleAViewnumber",number1,@"PreStyleAViewnumber", nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
//        //得到车速之后，发送转速
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130630D"]];
//    }
//    if (!(RotationalStr == nil)) {
//        [_CustomNumberArray replaceObjectAtIndex:1 withObject:RotationalStr];
//        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"29",@"StyleAViewTag",_CustomNumberArray[1],@"StyleAViewnumber",number2,@"PreStyleAViewnumber", nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
//        //发送水温
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130350D"]];
//        
//    }
//    if (!(WatertemperatureStr == nil)) {
//        [_CustomNumberArray replaceObjectAtIndex:2 withObject:WatertemperatureStr];
//        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"30",@"StyleAViewTag",_CustomNumberArray[2],@"StyleAViewnumber",number3,@"PreStyleAViewnumber", nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
//        
//        //得到水温之后，发送TF
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303131310D"]];
//    }
//    if (!(ThrottlePositionStr == nil)) {
//        [_CustomNumberArray replaceObjectAtIndex:3 withObject:ThrottlePositionStr];
//        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"31",@"StyleAViewTag",_CustomNumberArray[3],@"StyleAViewnumber",number4,@"PreStyleAViewnumber", nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
//        //得到TF之后，发送车速
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
//    }
//    
    
}

#pragma mark 对自定义不同风格进行更新
- (void)updateCustomType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(NSInteger)id{
    DLog(@"更新");
    CustomDashboard *dash = [CustomDashboard findByPK:id];
            switch (Customtype) {
                case 1:
                {
                    DLog(@"改变！！！！111");
                    dash.DashboardAorignx = [NSString stringWithFormat:@"%f",orignx];
                    dash.DashboardAorigny = [NSString stringWithFormat:@"%f",origny];
                    dash.DashboardAorignwidth = [NSString stringWithFormat:@"%f",width];
                    dash.DashboardAorignheight = [NSString stringWithFormat:@"%f",height];
                    
                }
                    break;
                case 2:
                {
                    dash.DashboardBorignx = [NSString stringWithFormat:@"%f",orignx];
                    dash.DashboardBorigny = [NSString stringWithFormat:@"%f",origny];
                    dash.DashboardBorignwidth = [NSString stringWithFormat:@"%f",width];
                    dash.DashboardBorignheight = [NSString stringWithFormat:@"%f",height];
                    
                    
                }
                    break;
                case 3:
                {
                    dash.DashboardCorignx = [NSString stringWithFormat:@"%f",orignx];
                    dash.DashboardCorigny = [NSString stringWithFormat:@"%f",origny];
                    dash.DashboardCorignwidth = [NSString stringWithFormat:@"%f",width];
                    dash.DashboardCorignheight = [NSString stringWithFormat:@"%f",height];
                    dash.DashboardCGradientradius = [NSString stringWithFormat:@"%f",width/2];
                }
                    break;
                default:
                    break;
            }
            [dash update];

}
#pragma mark 对经典不同风格进行更新
- (void)updateClassicType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(NSInteger)id{
    DLog(@"更新");
    CustomDashboard *dash = [CustomDashboard findByPK:id];
    dash.DashboardAorignx = [NSString stringWithFormat:@"%f",orignx];
    switch (Customtype) {
        case 1:
        {
                    dash.DashboardAorigny = [NSString stringWithFormat:@"%f",origny];
                    dash.DashboardAorignwidth = [NSString stringWithFormat:@"%f",width];
                    dash.DashboardAorignheight = [NSString stringWithFormat:@"%f",height];
                    [dash update];
        }
            break;
        case 2:
        {
                    dash.DashboardBorignx = [NSString stringWithFormat:@"%f",orignx];
                    dash.DashboardBorigny = [NSString stringWithFormat:@"%f",origny];
                    dash.DashboardBorignwidth = [NSString stringWithFormat:@"%f",width];
                    dash.DashboardBorignheight = [NSString stringWithFormat:@"%f",height];
                    [dash update];
        }
            break;
        case 3:
        {
                    dash.DashboardCorignx = [NSString stringWithFormat:@"%f",orignx];
                    dash.DashboardCorigny = [NSString stringWithFormat:@"%f",origny];
                    dash.DashboardCorignwidth = [NSString stringWithFormat:@"%f",width];
                    dash.DashboardCorignheight = [NSString stringWithFormat:@"%f",height];
                    dash.DashboardCGradientradius = [NSString stringWithFormat:@"%f",width/2];
                    [dash update];
        }
            break;
        default:
            break;
    }
}
//发送指令
- (void)startAnimation{
    
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    //发送车速
    [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
}


- (void)initWithData{
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];
    
    self.numberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    _CustomLabelArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];
    
    self.CustomNumberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                              @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    
    
    NSArray *pAllCount = [CustomDashboard findAll];
    CustomDashboard *modle = pAllCount.lastObject;
    NSInteger space =   modle.pk  - _CustomLabelArray.count;
    if (space > 0) {
        for (int i = 1; i<=space; i++) {
            [_CustomLabelArray addObject:@"add"];
            [self.CustomNumberArray  addObject:@"12"];
        }
    }
    for (int i = 0; i<_numberArray.count; i++) {
        [_numberArray  replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
    }
    for (int i = 0; i<_CustomLabelArray.count; i++) {
        [self.CustomNumberArray    replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%u", arc4random() % 100]];
    }
}
- (void)initWithUI{

    //创建滚动视图
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*[DashboardSetting sharedInstance].KPageNumer,0);
    scrollView.pagingEnabled = YES;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewtap)] ];
    [self.view addSubview:scrollView];
    //  添加页数控制视图 new = alloc + init
    pageControl = [UIPageControl new];
    //不要加到滚动视图中， 会随着滚动消失掉
    [self.view addSubview:pageControl];
    //    设置常用属性,距离屏幕下方60像素。
    pageControl.frame = CGRectMake(0, MSHeight- self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -40, MSWidth, 30);
    //    设置圆点的个数
    pageControl.numberOfPages = [DashboardSetting sharedInstance].KPageNumer;
    //    设置没有被选中时圆点的颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    //    设置选中时圆点的颜色
    pageControl.currentPageIndicatorTintColor = [ColorTools colorWithHexString:@"#FE9002"];
    //    关闭分页控件的用户交互功能
    pageControl.userInteractionEnabled = NO;
    // 为了检测滚动视图的偏移量，引入代理
    scrollView.delegate = self;
    pageControl.tag = 1000;
    [self LoadUI];
}
- (void)LoadUI{
    //判断仪表盘模式：
    if ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] == DashboardCustomMode) {
        [self initWithcustomMode];
         DLog(@"已经来到");
        if ([DashboardSetting sharedInstance].isAddDashboard == YES) {
            [self addDashboard];
            [DashboardSetting sharedInstance].isAddDashboard = NO;
        }
        
    }else{
        switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardStyle"]) {
            case DashboardStyleOne:
            {
                [self initWithStyleA];
            }
                break;
            case DashboardStyleTwo:
            {
                [self initWithStyleB];
            }
                break;
            case DashboardStyleThree:
            {
                [self initWithStyleC];
            }
                break;
            default:
                break;
        }
    }
    
    if ([DashboardSetting sharedInstance].isDashboardRemove == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Display" message:@"Are you sure you want to remove this item?" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            [DashboardSetting sharedInstance].isDashboardRemove = NO;
        }]];
        __weak __typeof(&*self)weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf RemoveDisplay];
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
}
- (void)back{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DLog(@"停止停止");
        [weakSelf stopSend];
    });
    [editview hide];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)stopSend{
    DLog(@"停止停止");
    self.blueTooth.stopSend = YES;
}
- (void)initWithcustomMode{
    DLog(@"仪表盘");
//    testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight)];
    NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK > 27"];
    for (NSInteger i = 0;i<pAllCount.count;i++) {
        CustomDashboard *dash = pAllCount[i];
        DLog(@"orignx%ld--%@",(long)dash.pk,dash.DashboardAorignx);
        if (dash.dashboardType == 1) {
            dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.DashboardAorignx doubleValue], [dash.DashboardAorigny doubleValue], [dash.DashboardAorignwidth doubleValue], [dash.DashboardAorignheight doubleValue])];
            [self initWithCustomDashboardAFrame:dash];
        }
        if (dash.dashboardType == 2){
            dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.DashboardBorignx doubleValue], [dash.DashboardBorigny doubleValue], [dash.DashboardBorignwidth doubleValue], [dash.DashboardBorignheight doubleValue])];
            dashboardStyleBView.tag =dash.pk ;
            [dashboardStyleBView initWithModel:dash];
            DashBoardTag = dashboardStyleBView.tag ;
            dashboardStyleBView.delegate =self;
            dashboardStyleBView.PIDLabel.text = _CustomLabelArray[DashBoardTag-1-27];
            dashboardStyleBView.NumberLabel.text = _CustomNumberArray[DashBoardTag-1-27];
            dash.DashboardBinfoLabeltext = dashboardStyleBView.PIDLabel.text;
            if ([dash.DashboardBinfoLabeltext isEqualToString:@"RPM"]) {
                dash.DashboardBmaxNumber = [NSString stringWithFormat:@"1000"] ;
            }
            [dash update];
            [scrollView addSubview:dashboardStyleBView];
            [self MoveDashboard: dashboardStyleBView.tag];
        }
        if (dash.dashboardType == 3){
            dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.DashboardCorignx doubleValue], [dash.DashboardCorigny doubleValue], [dash.DashboardCorignwidth doubleValue], [dash.DashboardCorignheight doubleValue])];
            dashboardStyleCView.tag = dash.pk ;
            [dashboardStyleCView initWithModel:dash];
            DashBoardTag = dashboardStyleCView.tag ;
            dashboardStyleCView.delegate = self;
            dashboardStyleCView.PIDLabel.text = _CustomLabelArray[DashBoardTag-1-27];
            dashboardStyleCView.NumberLabel.text = _CustomNumberArray[DashBoardTag-1-27];
            dash.DashboardCinfoLabeltext = dashboardStyleCView.PIDLabel.text;
            if ([dash.DashboardAinfoLabeltext isEqualToString:@"RPM"]) {
                dash.DashboardAmaxNumber = [NSString stringWithFormat:@"1000"] ;
            }
            [dash update];
            [scrollView addSubview:dashboardStyleCView];
            [self MoveDashboard: dashboardStyleAView.tag];
        }
    }
}

#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    DashBoardTag = 0;
    NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE  PK < 10"];
    for (CustomDashboard *dash in pAllCount) {
        DLog(@"总共%ld,orignx=%f",(long)dash.pk, [dash.DashboardAorignx doubleValue]);
        dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.DashboardAorignx doubleValue], [dash.DashboardAorigny doubleValue], [dash.DashboardAorignwidth doubleValue], [dash.DashboardAorignheight doubleValue])];
        [self initwithDashboardAFrame:dash];
    }
}


- (void)initWithStyleB{
    DashBoardTag = 0;
    NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK >=10 and PK < 19"];
    for (CustomDashboard *dash in pAllCount) {
        DLog(@"总共%ld",(long)dash.pk);
        DLog(@"_LabelNameArray%@",_LabelNameArray);
        
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.DashboardBorignx doubleValue], [dash.DashboardBorigny doubleValue], [dash.DashboardBorignwidth doubleValue], [dash.DashboardBorignheight doubleValue])];
        [dashboardStyleBView initWithModel:dash];
        dashboardStyleBView.tag = dash.pk ;
        DashBoardTag = dashboardStyleBView.tag ;
        dashboardStyleBView.delegate = self;
        dashboardStyleBView.PIDLabel.text = _LabelNameArray[dashboardStyleBView.tag-1-9];
        dashboardStyleBView.NumberLabel.text = _numberArray[dashboardStyleBView.tag-1-9];
        dash.DashboardBinfoLabeltext = dashboardStyleBView.PIDLabel.text;
        [dash update];
        [scrollView addSubview:dashboardStyleBView];
    }
    
}


- (void)initWithStyleC{
    DashBoardTag = 0;
    NSArray* pAllCount = [CustomDashboard findByCriteria:@"WHERE PK >=19 and PK < 28"];
    for (CustomDashboard *dash in pAllCount) {
        
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.DashboardCorignx doubleValue], [dash.DashboardCorigny doubleValue], [dash.DashboardCorignwidth doubleValue], [dash.DashboardCorignheight doubleValue])];
        dashboardStyleCView.tag = dash.pk ;
        [dashboardStyleCView initWithModel:dash];
        DashBoardTag = dashboardStyleCView.tag ;
        dashboardStyleCView.delegate = self;
        dashboardStyleCView.PIDLabel.text = _LabelNameArray[dashboardStyleCView.tag -1-18];
        dashboardStyleCView.NumberLabel.text = _numberArray[dashboardStyleCView.tag -1-18];
        dash.DashboardCinfoLabeltext = dashboardStyleCView.PIDLabel.text;
        [scrollView addSubview:dashboardStyleCView];
        [dash update];
    }
    
}

//当滚动视图发生位移，就会进入下方代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:1000];
    //取得偏移量
    CGPoint point = scrollView.contentOffset;
    //根据滚动的位置来决定当前是第几页
    //可以用 round()  C语言方法进行 四舍五入操作
    NSInteger index = round(point.x/scrollView.frame.size.width);
    //设置分页控制器的当前页面
    pageControl.currentPage = index;
}

- (void)rightBarButtonClick{
    editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(MSWidth - 270, 50, 270 , 240)];
    editview.delegate = self;
    [editview show];
}

- (void)scrollViewtap{
    DLog(@"点击屏幕");
    [editview hide];
}
#pragma mark 点击选择仪表盘模式和风格按钮
- (void)selectStyleBtnBetouched:(NSInteger)index{
    DLog(@"tettet==%ld",(long)index);
    [self stopSend];
    
    [editview hide];
    // 关闭定时器
    //    dispatch_source_cancel(_timer);
    switch (index) {
        case 1:
        {
            
            SelectModeViewController *vc = [[SelectModeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            if ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] == DashboardClassicMode) {
                SelectStyleViewController *vc = [[SelectStyleViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark 点击设置列表的某一行2\3\4弹框
-(void)AlertBetouched:(NSInteger)index{
    [self stopSend];
    
    switch (index) {
        case 2:
        {
            //自定义模式
            //添加一个仪表盘
            if ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"] == DashboardCustomMode) {
                [DashboardSetting sharedInstance].isAddDashboard = YES;
                [DashboardSetting sharedInstance].CurrentPage = pageControl.currentPage;
                SelectStyleViewController *vc =   [[SelectStyleViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
            break;
        case 3:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Load Default Dashboards" message:@"This will delete all of the existing dashboards and load the default set of dashboards. Do you want to continue?" preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self LoadDefaultDashboards];
            }]];
            
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
            break;
        case 4:
        {
            //     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                DLog(@"停止停止");
            [self stopSend];
            //        });
            HUDViewController *vc = [[HUDViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark 捏合手势代理
- (void)pinchtap:(UIPinchGestureRecognizer *)sender OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height{
    DLog(@"*****DIDIDIDIDI%f \n %f \n %f \n %f",orignx,origny,width,height);
    CustomDashboard *dashboard = [CustomDashboard findByPK:sender.view.tag];
      dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:sender.view.tag];
     int page =  orignx/MSWidth;
    switch (dashboard.dashboardType) {
        case 1:
        {
            if (isLandscape) {
            [self updateCustomType:1 OrignX:SCREEN_MIN-origny-(height-30*KFontmultiple)-20*KFontmultiple OrignY:orignx-TopHigh-15*KFontmultiple-page*MSWidth Width:width Height:height ID:sender.view.tag];
            }else{
            [self updateCustomType:1 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
                }
            DLog(@"%@\n%@\n%@\n%@",dashboard.DashboardAorignx,dashboard.DashboardAorigny,dashboard.DashboardAorignwidth,dashboard.DashboardAorignheight)
        }
            break;
        case 2:
        {
            if (isLandscape) {
                [self updateCustomType:2 OrignX:SCREEN_MIN-origny-(height-30*KFontmultiple)-30*KFontmultiple+page*SCREEN_MIN OrignY:orignx-TopHigh-15*KFontmultiple-page*MSWidth Width:width Height:height ID:sender.view.tag];
            }else{
                [self updateCustomType:2 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
            DLog(@"%@\n%@\n%@\n%@",dashboard.DashboardBorignx,dashboard.DashboardBorigny,dashboard.DashboardBorignwidth,dashboard.DashboardBorignheight)
        }
            break;
        case 3:
        {
            if (isLandscape) {
                [self updateCustomType:3 OrignX:SCREEN_MIN-origny-(height-30*KFontmultiple)+page*SCREEN_MIN OrignY:orignx-TopHigh-15*KFontmultiple-page*MSWidth Width:width Height:height ID:sender.view.tag];
            }else{
                [self updateCustomType:3 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
            DLog(@"%@\n%@\n%@\n%@",dashboard.DashboardCorignx,dashboard.DashboardCorigny,dashboard.DashboardCorignwidth,dashboard.DashboardCorignheight)
        }
            break;
        default:
            break;
    }
}
#pragma mark 长按仪表盘的手势
- (void)tap:(UILongPressGestureRecognizer *)sender{
    DLog(@" [sender view].tag %ld", (long)sender.view.tag);
    [self stopSend];
    [DashboardSetting sharedInstance].Dashboardindex = sender.view.tag;
    DLog(@"aaa%ld",(long)[DashboardSetting sharedInstance].Dashboardindex);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            switch ([[UserDefaultSet sharedInstance] GetAttribute:@"dashboardMode"]) {
                case DashboardClassicMode:{
                    // 关闭定时器
                    //                    dispatch_source_cancel(_timer);
                    PIDSelectViewController *vc = [[PIDSelectViewController alloc]init ];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case DashboardCustomMode:{
                    // 关闭定时器
                    //                    dispatch_source_cancel(_timer);
                    
                    EditDisplayViewController *vc = [[EditDisplayViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
        }
            break;
        default:
            break;
    }
}



#pragma mark 全部恢复默认仪表盘
- (void)LoadDefaultDashboards{
    DLog(@"LoadLoad");
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CustomDashboard clearTable];
         [[DashboardSetting sharedInstance]initWithdashboardA];
         [[DashboardSetting sharedInstance]initWithdashboardB];
         [[DashboardSetting sharedInstance]initWithdashboardC];
         [[DashboardSetting sharedInstance]initwithCustomDashboard];
        [self clearAllUserDefaultsData];
       dispatch_async(dispatch_get_main_queue(), ^{
        [self updateView];
       });
 });
}
#pragma mark 使仪表盘移动到最前面
- (void)moveFoneView{
    
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].isDashboardFont == YES ) {
        DLog(@"CCqianm");
        CustomDashboard *dashboard =  [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
        switch (dashboard.dashboardType) {
            case 1:
            {
                DLog(@"1212");
                DashboardView *view = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [scrollView bringSubviewToFront:view];
            }
                break;
            case 2:
            {
                DashboardViewStyleB *view = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [[view superview] bringSubviewToFront:view];
            }
                break;
            case 3:
            {
                DashboardViewStyleC *view = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [[view superview] bringSubviewToFront:view];
            }
                break;
            default:
                break;
        }
        //            [DashboardSetting sharedInstance].isDashboardFont = NO;
    }
}
#pragma mark 点击移动仪表盘，让它变颜色；
- (void)MoveDashboard:(NSInteger)indexTag{
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == indexTag &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        DLog(@"CCC");
        scrollView.scrollEnabled = NO;
        CustomDashboard *dashboard = [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
        switch (dashboard.dashboardType) {
            case 1:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleAView.frame.size.width, dashboardStyleAView.frame.size.width)];
                coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                dashboardStyleAView.userInteractionEnabled = YES;
                coverView.alpha = 0.2;
                [dashboardStyleAView addSubview:coverView];
                
            }
                break;
            case 2:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleBView.frame.size.width, dashboardStyleBView.frame.size.width)];
                dashboardStyleBView.userInteractionEnabled = YES;
                coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                coverView.alpha = 0.2;
                [dashboardStyleBView addSubview:coverView];
            }
                break;
            case 3:
            {
                coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dashboardStyleCView.frame.size.width, dashboardStyleCView.frame.size.width)];
                dashboardStyleCView.userInteractionEnabled = YES;
                
                coverView.backgroundColor = [ColorTools colorWithHexString:@"#FE9002"];
                coverView.alpha = 0.2;
                [dashboardStyleCView addSubview:coverView];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 点击添加
- (void)addDashboard{
    DLog(@"点击添加one,%ld",(long)[DashboardSetting sharedInstance].CurrentPage );
    DLog(@"点击,%ld",(long)[DashboardSetting sharedInstance].addStyle );
    
    
    switch ([DashboardSetting sharedInstance].addStyle) {
        case AddStyleOne:
        {
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleOne withTag:0];
            
         DashboardView  * dashboardAView = [[DashboardView alloc ]initWithFrame:CGRectMake([DashboardSetting sharedInstance].CurrentPage *MSWidth +(arc4random() % (int)(MSWidth/2)), (arc4random() % (int)(MSHeight/2)), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardAView.tag = ++ DashBoardTag;
            dashboardAView.delegate =self;
           CustomDashboard *dashboard = [CustomDashboard findByPK:dashboardAView.tag];
            [dashboardAView addGradientView:dashboard.DashboardAouterColor GradientViewWidth:dashboardAView.frame.size.width];
                    [dashboardAView initWithModel:dashboard];
            [scrollView addSubview:dashboardAView];
            DLog(@"%f*****%f",dashboardAView.frame.origin.x,dashboardAView.frame.origin.y);

             if (isLandscape) {
       [self updateCustomType:1 OrignX:SCREEN_MIN-dashboardAView.frame.origin.y-(dashboardAView.frame.size.height-30*KFontmultiple)+[DashboardSetting sharedInstance].CurrentPage*SCREEN_MIN OrignY:dashboardAView.frame.origin.x-TopHigh-15*KFontmultiple-[DashboardSetting sharedInstance].CurrentPage*MSWidth Width:dashboardAView.frame.size.width Height:dashboardAView.frame.size.height ID:dashboardAView.tag];
             }else{[self updateCustomType:1 OrignX:dashboardAView.frame.origin.x OrignY:dashboardAView.frame.origin.y Width:dashboardAView.frame.size.width Height:dashboardAView.frame.size.height ID:dashboardAView.tag];
             }

        }
            break;
        case AddStyleTwo:
        {
        [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleTwo withTag:0];
            
        DashboardViewStyleB    *dashboardBView = [[DashboardViewStyleB alloc ]initWithFrame:CGRectMake([DashboardSetting sharedInstance].CurrentPage*MSWidth+(arc4random() % (int)(MSWidth/2)), (arc4random() % (int)(MSHeight/2) ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardBView.tag = ++ DashBoardTag;
            dashboardBView.delegate =self;
           CustomDashboard *dashboard = [CustomDashboard findByPK: dashboardBView.tag];
                [dashboardBView initWithModel:dashboard];
            [scrollView addSubview:dashboardBView];
DLog(@"%f*****%f",dashboardBView.frame.origin.x,dashboardBView.frame.origin.y);
            if (isLandscape) {
               [self updateCustomType:2 OrignX:SCREEN_MIN-dashboardBView.frame.origin.y-(dashboardBView.frame.size.height-30*KFontmultiple)+[DashboardSetting sharedInstance].CurrentPage*SCREEN_MIN OrignY:dashboardBView.frame.origin.x-TopHigh-15*KFontmultiple-[DashboardSetting sharedInstance].CurrentPage*MSWidth Width:dashboardBView.frame.size.width Height:dashboardBView.frame.size.height ID:dashboardBView.tag];
            }else{[self updateCustomType:2 OrignX:dashboardBView.frame.origin.x OrignY:dashboardBView.frame.origin.y Width:dashboardBView.frame.size.width Height:dashboardBView.frame.size.height ID:dashboardBView.tag];}
        }
            break;
        case AddStyleThree:
        {
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleThree withTag:0];
         DashboardViewStyleC  * dashboardCView = [[DashboardViewStyleC alloc ]initWithFrame:CGRectMake( [DashboardSetting sharedInstance].CurrentPage*MSWidth +(arc4random() % (int)(MSWidth/2)), (arc4random() % (int)(MSHeight/2) ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardCView.tag = ++ DashBoardTag;
            dashboardCView.delegate = self;
            CustomDashboard *dashboard = [CustomDashboard findByPK:dashboardCView.tag];
            [dashboardCView initWithModel:dashboard];
            [scrollView addSubview:dashboardCView];
            if (isLandscape) {
            [self updateCustomType:3 OrignX:SCREEN_MIN-dashboardCView.frame.origin.y-(dashboardCView.frame.size.height-30*KFontmultiple)+[DashboardSetting sharedInstance].CurrentPage*SCREEN_MIN OrignY:dashboardCView.frame.origin.x-TopHigh-15*KFontmultiple-[DashboardSetting sharedInstance].CurrentPage*MSWidth Width:dashboardCView.frame.size.width Height:dashboardCView.frame.size.height ID:dashboardCView.tag];
            }else{ [self updateCustomType:3 OrignX:dashboardCView.frame.origin.x OrignY:dashboardCView.frame.origin.y Width:dashboardCView.frame.size.width Height:dashboardCView.frame.size.height ID:dashboardCView.tag];
            }
            DLog(@"%f*****%f",dashboardCView.frame.origin.x,dashboardCView.frame.origin.y);

        }
            break;
            
        default:
            break;
    }

    
}
#pragma mark 点击移除
- (void)RemoveDisplay{
    [[UserDefaultSet sharedInstance].defaults setInteger:[[UserDefaultSet sharedInstance].defaults integerForKey:@"AddDashboardNumber"]-1 forKey:@"AddDashboardNumber"];
    
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    CustomDashboard *dashboard = [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
    switch (dashboard.dashboardType) {
        case 1:
        {
            dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            [dashboardStyleAView removeFromSuperview];
            
        }
            break;
        case 2:
        {
            dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            [dashboardStyleBView removeFromSuperview];
            
        }
            break;
        case 3:
        {
            dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
            [dashboardStyleCView removeFromSuperview];
        }
            break;
        default:
            break;
    }
 
    NSString *str = [NSString stringWithFormat:@"WHERE pk = %ld",(long)[DashboardSetting sharedInstance].Dashboardindex];
    [CustomDashboard  deleteObjectsByCriteria:str];

}
#pragma mark 更新最新的仪表盘
- (void)updateView{
    NSInteger current = pageControl.currentPage;
    [pageControl removeFromSuperview];
    [scrollView removeFromSuperview];
    [self initWithData];
    [self initWithUI];
    scrollView.contentOffset = CGPointMake(current*MSWidth, 0);
}
#pragma mark 移动代理
- (void)touchMoveWithcenterX:(CGFloat)centerX WithcenterY:(CGFloat)WithcenterY{
    DLog(@"****%f ---- %f",centerX,WithcenterY);
    int page =  centerX/MSWidth;
    scrollView.scrollEnabled = YES;
    [DashboardSetting sharedInstance].isDashboardMove = NO;
    CustomDashboard *dashboard = [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
    switch (dashboard.dashboardType) {
        case 1:
        {
            DLog(@"111");
            if (isLandscape) {
                dashboard.DashboardAorignx = [NSString stringWithFormat:@"%f",SCREEN_MIN-WithcenterY-([dashboard.DashboardAorignheight floatValue]-30*KFontmultiple)+page*SCREEN_MIN];
                dashboard.DashboardAorigny = [NSString stringWithFormat:@"%f",centerX-TopHigh-15*KFontmultiple-page*MSWidth];
            }else{
            dashboard.DashboardAorignx = [NSString stringWithFormat:@"%f",centerX];
            dashboard.DashboardAorigny = [NSString stringWithFormat:@"%f",WithcenterY];
            }
        }
            break;
        case 2:
        {
              if (isLandscape) {
                  dashboard.DashboardBorignx = [NSString stringWithFormat:@"%f",SCREEN_MIN-WithcenterY-([dashboard.DashboardBorignheight floatValue]-30*KFontmultiple)+page*SCREEN_MIN];
                  dashboard.DashboardBorigny = [NSString stringWithFormat:@"%f",centerX-TopHigh-15*KFontmultiple-page*MSWidth];
              }else{
            dashboard.DashboardBorignx = [NSString stringWithFormat:@"%f",centerX];
            dashboard.DashboardBorigny = [NSString stringWithFormat:@"%f",WithcenterY];
              }
        }
            break;
        case 3:
        {
            if (isLandscape) {
                dashboard.DashboardCorignx = [NSString stringWithFormat:@"%f",SCREEN_MIN-WithcenterY-([dashboard.DashboardCorignheight floatValue]-30*KFontmultiple)+page*MSWidth];
                dashboard.DashboardCorigny = [NSString stringWithFormat:@"%f",centerX-TopHigh-15*KFontmultiple-page*MSWidth];
            }else{
            dashboard.DashboardCorignx = [NSString stringWithFormat:@"%f",centerX];
            dashboard.DashboardCorigny = [NSString stringWithFormat:@"%f",WithcenterY];
            }
            break;
        default:
            break;
        }
    }
    //更新为当前的数据
    [dashboard update];
    [coverView removeFromSuperview];
    scrollView.scrollEnabled = YES;
    
    
    
}
#pragma mark 颜色转化
- (NSString *)hexFromUIColor:(UIColor *)color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

- (void)clearAllUserDefaultsData
{
    
    [UserDefaultSet sharedInstance].dashboardMode = DashboardCustomMode;
    [UserDefaultSet sharedInstance].dashboardStyle = DashboardStyleOne;
    [UserDefaultSet sharedInstance].numberDecimals = NumberDecimalZero;
    [UserDefaultSet sharedInstance].multiplierType = MultiplierType1;
    [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToNormal;
    [DashboardSetting sharedInstance].KPageNumer = 4;
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
}
@end

