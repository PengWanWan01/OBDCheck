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
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self updateView];
    if ([OBDLibTools sharedInstance].EnterSuccess == YES) {
        //请求PID
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[OBDLibTools sharedInstance] OBDIIDataStream];
        });
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}
#pragma mark 设置横竖屏布局

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //    [self initWithData];
    if (isLandscape) {
        //翻转为横屏时
        [self setHorizontalFrame];
    }else{
        //翻转为竖屏时
        
        [self setVerticalFrame];
    }
    DLog(@"旋转");
    //    [self moveFoneView];
    [editview layoutSubviews];
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    
    
    scrollView.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX);
    scrollView.contentSize = CGSizeMake(SCREEN_MIN*[[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"],0);
    pageControl.frame = CGRectMake(0, SCREEN_MAX- self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -40, SCREEN_MIN, 30);
    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardCustomMode) {
        NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:@"WHERE id > 27"] ;
        for (CustomDashboard *dash in pAllCount) {
            switch (dash.dashboardType) {
                case 1:
                {
                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.ID ];
                    [dashboardStyleAView layoutFrames];
                }
                    break;
                case 2:
                {
                    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.ID ];
                    [dashboardStyleBView layoutFrames];
                }
                    break;
                case 3:
                {
                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.ID];
                    [dashboardStyleCView layoutFrames];
                    
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardStyle"]) {
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
    scrollView.contentSize = CGSizeMake(SCREEN_MAX*[[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"],0);
    pageControl.frame = CGRectMake(0, SCREEN_MIN- TopHigh -20, SCREEN_MAX, 30);
//    editview.frame = 
    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardCustomMode) {
        NSString *SQLStr = [NSString stringWithFormat:@"WHERE id > 27"];
        NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
        for (CustomDashboard *dash in pAllCount) {

            switch (dash.dashboardType) {
                case 1:
                {
                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.ID ];
                    [dashboardStyleAView layoutFrames];
                }
                    break;
                case 2:
                {
                    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.ID ];
                    [dashboardStyleBView layoutFrames];
                }
                    break;
                case 3:
                {
                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.ID ];
                    [dashboardStyleCView layoutFrames];
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }else{
        switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardStyle"]) {
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
            
            NSString *SQLStr = [NSString stringWithFormat:@" WHERE id < 10"];
            NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.ID];
                [dashboardStyleAView layoutFrames];
            }
        }
            break;
        case DashboardStyleTwo:
        {
            NSString *SQLStr = [NSString stringWithFormat:@" WHERE id >=10 and id < 19"];
            NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
            for (CustomDashboard *dash in pAllCount) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.ID];
                [dashboardStyleBView layoutFrames];
            }
        }
            break;
        case DashboardStyleThree:
        {
            NSString *SQLStr = [NSString stringWithFormat:@"WHERE id >=19 and id < 28"];
            NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
              for (CustomDashboard *dash in pAllCount) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.ID];
                [dashboardStyleCView layoutFrames];
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
            NSString *SQLStr = [NSString stringWithFormat:@" WHERE id <10"];
            NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
             for (CustomDashboard *dash in pAllCount) {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:dash.ID];
                [dashboardStyleAView layoutFrames];
            }
        }
            break;
        case DashboardStyleTwo:
        {
            NSString *SQLStr = [NSString stringWithFormat:@"WHERE id >=10  and id < 19"];
            NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
             for (CustomDashboard *dash in pAllCount) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:dash.ID];
                [dashboardStyleBView layoutFrames];
            }
        }
            break;
        case DashboardStyleThree:
        {
            NSString *SQLStr = [NSString stringWithFormat:@" WHERE id >=19  and id < 28"];
            NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
             for (CustomDashboard *dash in pAllCount) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:dash.ID];
                [dashboardStyleCView layoutFrames];
            }
        }
            break;
        default:
            break;
    }
}

-(void)initwithDashboardAFrame:(CustomDashboard *)dashboardA{
    dashboardStyleAView.tag = dashboardA.ID ;
    //画底盘渐变色
    [dashboardStyleAView addGradientView:dashboardA.DashboardAouterColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
    [dashboardStyleAView initWithModel:dashboardA];
    dashboardStyleAView.delegate = self;
    [scrollView addSubview:dashboardStyleAView];
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
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    [OBDLibTools sharedInstance].backData  = data;
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




- (void)initWithData{

    
    self.numberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    
    self.CustomNumberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                              @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
}
- (void)initWithUI{
    
    //创建滚动视图
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight)];
    switch ([[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"]) {
        case DashboardClassicMode:
            {
               scrollView.contentSize = CGSizeMake(MSWidth*3,0);
            }
            break;
        case DashboardCustomMode:
        {
            scrollView.contentSize = CGSizeMake(MSWidth*[[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"],0);
        }
            break;
        default:
            break;
    }
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
    pageControl.numberOfPages = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"];
    //    设置没有被选中时圆点的颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    //    设置选中时圆点的颜色
    pageControl.currentPageIndicatorTintColor = [ColorTools colorWithHexString:@"#FE9002"];
    //    关闭分页控件的用户交互功能
//    pageControl.userInteractionEnabled = NO;
    // 为了检测滚动视图的偏移量，引入代理
    scrollView.delegate = self;
    pageControl.tag = 1000;
    [self LoadUI];
}
- (void)LoadUI{
    //判断仪表盘模式：
    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardCustomMode) {
        [self initWithcustomMode];
        DLog(@"已经来到");
    }else{
        switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardStyle"]) {
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
    NSString *SQLStr = [NSString stringWithFormat:@" WHERE id > 27"];
    NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
     for (CustomDashboard *dash in pAllCount) {
        if (dash.dashboardType == 1) {
            dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue])];
            [self initwithDashboardAFrame:dash];
        }
        if (dash.dashboardType == 2){
            dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue])];
            dashboardStyleBView.tag =dash.ID ;
            [dashboardStyleBView initWithModel:dash];
            dashboardStyleBView.delegate =self;
            [scrollView addSubview:dashboardStyleBView];
            [self MoveDashboard: dashboardStyleBView.tag];
        }
        if (dash.dashboardType == 3){
            dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue])];
            dashboardStyleCView.tag = dash.ID ;
            [dashboardStyleCView initWithModel:dash];
            dashboardStyleCView.delegate = self;
            [scrollView addSubview:dashboardStyleCView];
            [self MoveDashboard: dashboardStyleCView.tag];
        }
    }
}

#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    NSString *SQLStr = [NSString stringWithFormat:@" WHERE id <10 "];
    NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr];
     for (CustomDashboard *dash in pAllCount) {
        dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue])];
        [self initwithDashboardAFrame:dash];
    }
}


- (void)initWithStyleB{
    NSString *SQLStr = [NSString stringWithFormat:@"WHERE id >=10  and id < 19"];
    NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
     for (CustomDashboard *dash in pAllCount) {
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue])];
        [dashboardStyleBView initWithModel:dash];
        dashboardStyleBView.tag = dash.ID ;
        dashboardStyleBView.delegate = self;
        [scrollView addSubview:dashboardStyleBView];
    }
    
}


- (void)initWithStyleC{
    NSString *SQLStr = [NSString stringWithFormat:@" WHERE id >=19  and id < 28"];
    NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
   for (CustomDashboard *dash in pAllCount) {
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.Dashboardorignx doubleValue], [dash.Dashboardorigny doubleValue], [dash.Dashboardorignwidth doubleValue], [dash.Dashboardorignheight doubleValue])];
        dashboardStyleCView.tag = dash.ID ;
        [dashboardStyleCView initWithModel:dash];
        dashboardStyleCView.delegate = self;
        [scrollView addSubview:dashboardStyleCView];
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
    switch ([[UserDefaultSet sharedInstance]GetIntegerAttribute:@"dashboardMode"]) {
        case DashboardCustomMode:
        {
            editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(MSWidth - 270, 50, 270 , 370)];
        }
            break;
        case DashboardClassicMode:
        {
            editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(MSWidth - 270, 50, 270 , 240)];
        }
            break;
        default:
            break;
    }
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
            if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardClassicMode) {
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
               AddBoardStyleController  *vc =   [[AddBoardStyleController alloc]init];
                vc.Currentpage = pageControl.currentPage;
                [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"]) {
                case DashboardClassicMode:{
                    [self LoadDefault];
                }
                    break;
                case DashboardCustomMode:{
                    DLog(@"添加一页");
                    
                    NSInteger page = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"]+1;
                    [[UserDefaultSet sharedInstance] SetIntegerAttribute:page Key:@"KPageNumer"];
                    scrollView.contentSize = CGSizeMake(MSWidth*[[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"],0);
                    pageControl.numberOfPages = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"];
                }
                    break;
                default:
                    break;
            }
    
        }
            break;
        case 4:
        {
            switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"]) {
                case DashboardClassicMode:{
                    [self LoadHUD];
                }
                    break;
                case DashboardCustomMode:{
                    DLog(@"删除当前页");
                    NSInteger page = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"]-1;
                    [self alterDashboardPage:page];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:
        {
            [self LoadDefault];
        }
            break;
        case 6:
        {
            [self LoadHUD];
          
        }
            break;
        case 7:
        {
            screenShotController *vc = [[screenShotController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark 恢复到默认状态
- (void)LoadDefault{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Load Default Dashboards" message:@"This will delete all of the existing dashboards and load the default set of dashboards. Do you want to continue?" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LoadDefaultDashboards];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark 进入HUD模式
- (void)LoadHUD{
    HUDViewController *vc = [[HUDViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 修改仪表盘的页数
-(void)alterDashboardPage:(NSInteger)page{
      [[UserDefaultSet sharedInstance] SetIntegerAttribute:page Key:@"KPageNumer"];
//     scrollView.contentSize = CGSizeMake(MSWidth*[[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"],0);
//    pageControl.numberOfPages = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"KPageNumer"];
    DLog(@"当前页为:%ld",(long)pageControl.currentPage);
    NSString *SQLStr = [NSString stringWithFormat:@" WHERE id>27"];
    NSArray *pAllCount = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withConditionStr:SQLStr] ;
    for (CustomDashboard *model in pAllCount) {
                if (pageControl.currentPage == 0) {
                    if ([model.Dashboardorignx doubleValue]<SCREEN_MIN) {
                        [[OBDataModel sharedDataBase]DeleteTableName:@"Dashboards" withID:model.ID];
                    }else{
                        model.Dashboardorignx = [NSString stringWithFormat:@"%f",[model.Dashboardorignx doubleValue] - SCREEN_MIN];
                    }
                }else{
                    if(([model.Dashboardorignx doubleValue]<(pageControl.currentPage+1)*SCREEN_MIN) && (([model.Dashboardorignx doubleValue]>pageControl.currentPage*SCREEN_MIN))) {
                        [[OBDataModel sharedDataBase]DeleteTableName:@"Dashboards" withID:model.ID];
                    }else if ([model.Dashboardorignx doubleValue]>(pageControl.currentPage+1)*SCREEN_MIN){
                         model.Dashboardorignx = [NSString stringWithFormat:@"%f",[model.Dashboardorignx doubleValue] - SCREEN_MIN];
                    }
                }
       [[OBDataModel sharedDataBase]updateTableName:@"Dashboards" withdata:[model yy_modelToJSONString] withID:model.ID];

            }
       
  
    [self updateView];
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * 3;
//    frame.origin.y = 0;
//    [scrollView scrollRectToVisible:frame animated:YES];

}
#pragma mark 捏合手势代理
- (void)pinchtap:(UIPinchGestureRecognizer *)sender OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height{
    DLog(@"*****DIDIDIDIDI%f \n %f \n %f \n %f",orignx,origny,width,height);
    CustomDashboard *dash = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:sender.view.tag].lastObject;
    int page =  orignx/MSWidth;
    
    if (isLandscape) {
        dash.Dashboardorignx = [NSString stringWithFormat:@"%f",SCREEN_MIN-origny-(height-30*KFontmultiple)-20*KFontmultiple];
        dash.Dashboardorigny = [NSString stringWithFormat:@"%f",orignx-TopHigh-15*KFontmultiple-page*MSWidth];
    }else{
        dash.Dashboardorignx = [NSString stringWithFormat:@"%f",orignx];
        dash.Dashboardorigny = [NSString stringWithFormat:@"%f",origny];
    }
    dash.Dashboardorignwidth = [NSString stringWithFormat:@"%f",width];
    dash.Dashboardorignheight = [NSString stringWithFormat:@"%f",height];
      [[OBDataModel sharedDataBase]updateTableName:@"Dashboards" withdata:[dash yy_modelToJSONString] withID:dash.ID];
}
#pragma mark 长按仪表盘的手势
- (void)tap:(UILongPressGestureRecognizer *)sender{
    DLog(@" [sender view].tag %ld", (long)sender.view.tag);
    [self stopSend];
    [DashboardSetting sharedInstance].Dashboardindex = sender.view.tag;
    DLog(@"aaa%ld",(long)[DashboardSetting sharedInstance].Dashboardindex);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"]) {
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
    [[OBDataModel sharedDataBase]dropTable:@"Dashboards"];
    
    [[UserDefaultSet sharedInstance]SetDefultAttribute]; //回复设置默认属性,
    [[OBDataModel sharedDataBase]initDataBase];
    [[DashboardSetting sharedInstance]initWithdashboardA];
    [[DashboardSetting sharedInstance]initWithdashboardB];
    [[DashboardSetting sharedInstance]initWithdashboardC];
    [[DashboardSetting sharedInstance]initwithCustomDashboard];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView];
        });
}
#pragma mark 使仪表盘移动到最前面
- (void)moveFoneView{
    
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].isDashboardFont == YES ) {
        DLog(@"CCqianm");
        CustomDashboard *dashboard =  [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:[DashboardSetting sharedInstance].Dashboardindex].lastObject;
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
        CustomDashboard *dashboard =  [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:[DashboardSetting sharedInstance].Dashboardindex].lastObject;
        
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

#pragma mark 点击移除
- (void)RemoveDisplay{
    [[UserDefaultSet sharedInstance].defaults setInteger:[[UserDefaultSet sharedInstance].defaults integerForKey:@"AddDashboardNumber"]-1 forKey:@"AddDashboardNumber"];
    
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    CustomDashboard *dashboard = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:[DashboardSetting sharedInstance].Dashboardindex].lastObject;
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
      [[OBDataModel sharedDataBase]DeleteTableName:@"Dashboards" withID:[DashboardSetting sharedInstance].Dashboardindex];
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
    
    CustomDashboard *dashboard = [[OBDataModel sharedDataBase]findTable:@"Dashboards" withID:[DashboardSetting sharedInstance].Dashboardindex].lastObject;
    if (isLandscape) {
        dashboard.Dashboardorignx = [NSString stringWithFormat:@"%f",SCREEN_MIN-WithcenterY-([dashboard.Dashboardorignheight floatValue]-30*KFontmultiple)+page*SCREEN_MIN];
        dashboard.Dashboardorigny = [NSString stringWithFormat:@"%f",centerX-TopHigh-15*KFontmultiple-page*MSWidth];
    }else{
        dashboard.Dashboardorignx = [NSString stringWithFormat:@"%f",centerX];
        dashboard.Dashboardorigny = [NSString stringWithFormat:@"%f",WithcenterY];
    }
    //更新为当前的数据
    [[OBDataModel sharedDataBase]updateTableName:@"Dashboards" withdata:[dashboard yy_modelToJSONString] withID:dashboard.ID];
    
    [coverView removeFromSuperview];
    scrollView.scrollEnabled = YES;
    
}


@end

