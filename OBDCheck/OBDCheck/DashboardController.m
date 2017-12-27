//
//  DashboardController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardController.h"
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
    UIView  *lineView;
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

    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;//竖屏
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
   
    [self updateView];
    [self startAnimation];

}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self initWithData];
      DLog(@"000--%f",TopHigh);
        if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        }else{
            //翻转为竖屏时
            DLog(@"竖屏");
            [self setVerticalFrame];
        }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
  
    
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    scrollView.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX);
     scrollView.contentSize = CGSizeMake(SCREEN_MIN*[DashboardSetting sharedInstance].KPageNumer,0);
     pageControl.frame = CGRectMake(0, SCREEN_MAX- self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height -40, SCREEN_MIN, 30);
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
        NSArray* pAllCount = [CustomDashboard bg_findAll];
        for (CustomDashboard *dash in pAllCount) {
            DLog(@"$$$$$$$$$$%ld",(long)dash.dashboardType);
            switch (dash.dashboardType) {
                case 1:
                    {
                        dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[dash.bg_id intValue]];
                        [dashboardStyleAView removeFromSuperview];
                        dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.dashboardA.orignx doubleValue], [dash.dashboardA.origny doubleValue], [dash.dashboardA.orignwidth doubleValue], [dash.dashboardA.orignheight doubleValue])];
                        [self initWithCustomDashboardAFrame:dash];
                    }
                    break;
                case 2:
                {
                    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[dash.bg_id intValue]];
                    dashboardStyleBView.frame = CGRectMake([dash.dashboardB.orignx doubleValue],[dash.dashboardB.origny doubleValue], [dash.dashboardB.orignwidth doubleValue], [dash.dashboardB.orignheight doubleValue]);
                    [dashboardStyleBView setNeedsLayout];
                }
                    break;
                case 3:
                {
                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[dash.bg_id intValue]];
                    dashboardStyleCView.frame = CGRectMake([dash.dashboardC.orignx doubleValue],[dash.dashboardC.origny doubleValue], [dash.dashboardC.orignwidth doubleValue], [dash.dashboardC.orignheight doubleValue]);
                    [dashboardStyleCView setNeedsLayout];
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
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
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    scrollView.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN);
    scrollView.contentSize = CGSizeMake(SCREEN_MAX*[DashboardSetting sharedInstance].KPageNumer,0);
     pageControl.frame = CGRectMake(0, SCREEN_MIN- TopHigh -20, SCREEN_MAX, 30);
   
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
        NSArray* pAllCount = [CustomDashboard bg_findAll];
        for (CustomDashboard *dash in pAllCount) {
            switch (dash.dashboardType) {
                case 1:
                    {
                        int page =  [dash.dashboardA.orignx doubleValue]/SCREEN_MIN;
                        DLog(@"333====%d",page);
                        dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[dash.bg_id intValue]];
                        [dashboardStyleAView removeFromSuperview];
                if (([dash.dashboardA.orignx floatValue]-page*SCREEN_MIN)>SCREEN_MIN/2) {
                    DLog(@"111111");
                   dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.dashboardA.origny floatValue]+TopHigh+page*SCREEN_MAX+15*KFontmultiple, [dash.dashboardA.orignx floatValue]-page*SCREEN_MIN-TopHigh+20*KFontmultiple, [dash.dashboardA.orignwidth doubleValue]-30*KFontmultiple, [dash.dashboardA.orignheight doubleValue]-30*KFontmultiple)];
                        }else{
                             dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.dashboardA.origny floatValue]+TopHigh+page*SCREEN_MAX+15*KFontmultiple, [dash.dashboardA.orignx floatValue]-page*SCREEN_MIN-TopHigh+40*KFontmultiple, [dash.dashboardA.orignwidth doubleValue]-30*KFontmultiple, [dash.dashboardA.orignheight doubleValue]-30*KFontmultiple)];
                        }
                        [self initWithCustomDashboardAFrame:dash];
                    }
                    break;
                case 2:
                {
                     int page =  [dash.dashboardB.orignx doubleValue]/SCREEN_MIN;
                    DLog(@"333====%d",page);
                    dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[dash.bg_id intValue]];
                    dashboardStyleBView.frame = CGRectMake([dash.dashboardB.origny floatValue]+page*SCREEN_MAX+TopHigh,[dash.dashboardB.orignx floatValue]-page*SCREEN_MIN-TopHigh, [dash.dashboardB.orignwidth doubleValue] ,[dash.dashboardB.orignheight doubleValue]);
                    [dashboardStyleBView setNeedsLayout];
                }
                    break;
                case 3:
                {
                    int page =  [dash.dashboardC.orignx doubleValue]/SCREEN_MIN;
                    DLog(@"333====%d",page);
                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[dash.bg_id intValue]];
                    dashboardStyleCView.frame = CGRectMake([dash.dashboardC.origny floatValue]+page*SCREEN_MAX+TopHigh, [dash.dashboardC.orignx floatValue]-page*SCREEN_MIN-TopHigh,  [dash.dashboardC.orignwidth doubleValue] , [dash.dashboardC.orignheight doubleValue]);
                    [dashboardStyleCView setNeedsLayout];
                    
                }
                    break;
                default:
                    break;
            }
        }
        
    }else{
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
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
                NSArray* pAllCount = [DashboardA bg_findAll];
                for (DashboardA *dash in pAllCount) {
                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[dash.bg_id intValue]];
                    [dashboardStyleAView removeFromSuperview];
                      int page =  [dash.orignx doubleValue]/SCREEN_MIN;
                    if (([dash.orignx floatValue]-page*SCREEN_MIN)>SCREEN_MIN/2) {
                        DLog(@"111111");
                        dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.origny floatValue]+TopHigh+page*SCREEN_MAX+15*KFontmultiple, [dash.orignx floatValue]-page*SCREEN_MIN-TopHigh+20*KFontmultiple, [dash.orignwidth doubleValue]-30*KFontmultiple, [dash.orignheight doubleValue]-30*KFontmultiple)];
                    }else{
                        dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.origny floatValue]+TopHigh+page*SCREEN_MAX+15*KFontmultiple, [dash.orignx floatValue]-page*SCREEN_MIN-TopHigh+40*KFontmultiple, [dash.orignwidth doubleValue]-30*KFontmultiple, [dash.orignheight doubleValue]-30*KFontmultiple)];
                    }
                     [self initwithDashboardAFrame:dash];
                }
            }
            break;
        case DashboardStyleTwo:
        {
            NSArray* pAllCount = [DashboardB bg_findAll];
            for (DashboardB *dash in pAllCount) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[dash.bg_id intValue]];
                int page =  [dash.orignx doubleValue]/SCREEN_MIN;
                if (([dash.orignx floatValue]-page*SCREEN_MIN)>SCREEN_MIN/2) {
                dashboardStyleBView.frame = CGRectMake([dash.origny floatValue]+page*SCREEN_MAX+TopHigh+15*KFontmultiple, [dash.orignx floatValue]-page*SCREEN_MIN-TopHigh+20*KFontmultiple, [dash.orignwidth doubleValue]-30*KFontmultiple, [dash.orignheight doubleValue]-30*KFontmultiple);
                }else{
                    dashboardStyleBView.frame = CGRectMake([dash.origny floatValue]+page*SCREEN_MAX+TopHigh+15*KFontmultiple, [dash.orignx floatValue]-page*SCREEN_MIN-TopHigh+40*KFontmultiple, [dash.orignwidth doubleValue]-30*KFontmultiple, [dash.orignheight doubleValue]-30*KFontmultiple);
                }
                [dashboardStyleBView setNeedsLayout];
            }
        }
            break;
        case DashboardStyleThree:
        {
            NSArray* pAllCount = [DashboardC bg_findAll];
            for (DashboardC *dash in pAllCount) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[dash.bg_id intValue]];
                int page =  [dash.orignx doubleValue]/SCREEN_MIN;
                  if (([dash.orignx floatValue]-page*SCREEN_MIN)>SCREEN_MIN/2) {
                      dashboardStyleCView.frame = CGRectMake([dash.origny floatValue]+page*SCREEN_MAX+TopHigh+15*KFontmultiple, [dash.orignx floatValue]-page*SCREEN_MIN-TopHigh+20*KFontmultiple,  [dash.orignwidth doubleValue]-30*KFontmultiple , [dash.orignheight doubleValue]-30*KFontmultiple);
                  }else{
                        dashboardStyleCView.frame = CGRectMake([dash.origny floatValue]+page*SCREEN_MAX+TopHigh+15*KFontmultiple, [dash.orignx floatValue]-page*SCREEN_MIN-TopHigh+40*KFontmultiple,  [dash.orignwidth doubleValue]-30*KFontmultiple , [dash.orignheight doubleValue]-30*KFontmultiple);
                  }
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
                NSArray* pAllCount = [DashboardA bg_findAll];
                for (DashboardA *dash in pAllCount) {
                    DLog(@"222%@",dash.bg_id);
                    dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[dash.bg_id intValue]];
                    [dashboardStyleAView removeFromSuperview];
                    dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
                    [self initwithDashboardAFrame:dash];
                }
            }
            break;
        case DashboardStyleTwo:
        {
            NSArray* pAllCount = [DashboardB bg_findAll];

            for (DashboardB *dash in pAllCount) {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[dash.bg_id intValue]];
                dashboardStyleBView.frame = CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue],[dash.orignheight doubleValue]);
                [dashboardStyleBView setNeedsLayout];
            }
        }
            break;
        case DashboardStyleThree:
        {
            NSArray* pAllCount = [DashboardC bg_findAll];
            for (DashboardC *dash in pAllCount) {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[dash.bg_id intValue]];
                dashboardStyleCView.frame = CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue],[dash.orignheight doubleValue]);
                [dashboardStyleCView setNeedsLayout];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark横竖屏之后调整Frame
-(void)initWithCustomDashboardAFrame:(CustomDashboard *)customDashboard{
    dashboardStyleAView.tag = [customDashboard.bg_id integerValue];
    DashBoardTag = dashboardStyleAView.tag ;
    [dashboardStyleAView addGradientView:customDashboard.dashboardA.outerColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
    dashboardStyleAView.delegate = self;
    if (!(customDashboard.dashboardA == nil)) {
        [dashboardStyleAView initWithModel:customDashboard.dashboardA];
    }
    dashboardStyleAView.infoLabel.text = _CustomLabelArray[[customDashboard.bg_id integerValue]  - 1];
    dashboardStyleAView.numberLabel.text = _CustomNumberArray[[customDashboard.bg_id integerValue]  - 1];
    customDashboard.dashboardA.infoLabeltext = dashboardStyleAView.infoLabel.text;
    [customDashboard bg_saveOrUpdate];
    [scrollView addSubview:dashboardStyleAView];
    [self MoveDashboard: dashboardStyleAView.tag];
}
-(void)initwithDashboardAFrame:(DashboardA *)dashboardA{
    dashboardStyleAView.tag = [dashboardA.bg_id integerValue];
    //画底盘渐变色
    [dashboardStyleAView addGradientView:dashboardA.outerColor  GradientViewWidth:dashboardStyleAView.frame.size.width];
    [dashboardStyleAView initWithModel:dashboardA];
    dashboardStyleAView.delegate = self;
    DashBoardTag = dashboardStyleAView.tag ;
    dashboardStyleAView.infoLabel.text = _LabelNameArray[DashBoardTag - 1];
    dashboardStyleAView.numberLabel.text = _numberArray[DashBoardTag - 1];
    dashboardA.infoLabeltext = dashboardStyleAView.infoLabel.text;
    [dashboardA bg_saveOrUpdate];
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
    NSString *number1 = _CustomNumberArray[0];
    NSString *number2 = _CustomNumberArray[1];
    NSString *number3 = _CustomNumberArray[2];
    NSString *number4 = _CustomNumberArray[3];

    DLog(@"收到收到%@",data);
    
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DLog(@"%@",string);
    NSString *VehicleSpeedStr = [BlueTool isVehicleSpeed:string];
    NSString *RotationalStr = [BlueTool isRotational:string];
    NSString *WatertemperatureStr = [BlueTool isWatertemperature:string];
    NSString *ThrottlePositionStr = [BlueTool isThrottlePosition:string];
    DLog(@"车速%@",VehicleSpeedStr);
    DLog(@"转速%@",RotationalStr);
    DLog(@"水温%@",WatertemperatureStr);
    DLog(@"TF%@",ThrottlePositionStr);

    if (!(VehicleSpeedStr == nil)) {
    
            [_CustomNumberArray replaceObjectAtIndex:0 withObject:VehicleSpeedStr];
            NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"StyleAViewTag",_CustomNumberArray[0],@"StyleAViewnumber",number1,@"PreStyleAViewnumber", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
            //得到车速之后，发送转速
            [self.blueTooth SendData:[BlueTool hexToBytes:@"303130630D"]];
    }
    if (!(RotationalStr == nil)) {
            [_CustomNumberArray replaceObjectAtIndex:1 withObject:RotationalStr];
            NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"StyleAViewTag",_CustomNumberArray[1],@"StyleAViewnumber",number2,@"PreStyleAViewnumber", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
            //发送水温
            [self.blueTooth SendData:[BlueTool hexToBytes:@"303130350D"]];
        
    }
    if (!(WatertemperatureStr == nil)) {
            [_CustomNumberArray replaceObjectAtIndex:2 withObject:WatertemperatureStr];
            NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"3",@"StyleAViewTag",_CustomNumberArray[2],@"StyleAViewnumber",number3,@"PreStyleAViewnumber", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
            //得到水温之后，发送TF
            [self.blueTooth SendData:[BlueTool hexToBytes:@"303131310D"]];
    }
    if (!(ThrottlePositionStr == nil)) {
            [_CustomNumberArray replaceObjectAtIndex:3 withObject:ThrottlePositionStr];
            NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"4",@"StyleAViewTag",_CustomNumberArray[3],@"StyleAViewnumber",number4,@"PreStyleAViewnumber", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
            //得到TF之后，发送车速
            [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
    }
    
    
}

#pragma mark 对自定义不同风格进行更新
- (void)updateCustomType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(NSInteger)id{
    DLog(@"更新");
    NSArray *he = [CustomDashboard bg_findAll];
    for (int i = 0; i<he.count; i++) {
        CustomDashboard *dash =he[i];
        
        if ([dash.bg_id integerValue] == id ) {
               DLog(@"orignx%ld",(long)dash.bg_id);
    switch (Customtype) {
        case 1:
        {
         
            dash.dashboardA.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardA.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardA.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardA.orignheight = [NSNumber numberWithFloat:height];

        }
            break;
        case 2:
        {
            dash.dashboardB.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardB.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardB.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardB.orignheight = [NSNumber numberWithFloat:height];
          

        }
            break;
        case 3:
        {
            dash.dashboardC.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardC.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardC.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardC.orignheight = [NSNumber numberWithFloat:height];
            dash.dashboardC.Gradientradius = [NSNumber numberWithFloat:width/2];
        }
            break;
        default:
            break;
    }
    [dash bg_saveOrUpdate];
        }
    }
}
#pragma mark 对经典不同风格进行更新
- (void)updateClassicType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(NSInteger)id{
    DLog(@"更新");
  
            switch (Customtype) {
                case 1:
                {
                    NSArray *he = [DashboardA bg_findAll];
                    for (int i = 0; i<he.count; i++) {
                        DashboardA *dash =he[i];
                        
                    if ([dash.bg_id integerValue] == id ) {
                            DLog(@"orignx%ld",(long)dash.bg_id);
                    dash.orignx = [NSNumber numberWithFloat:orignx];
                    dash.origny = [NSNumber numberWithFloat:origny];
                    dash.orignwidth = [NSNumber numberWithFloat:width];
                    dash.orignheight = [NSNumber numberWithFloat:height];
                            [dash bg_saveOrUpdate];
                        }
                    }
                }
                    break;
                case 2:
                {
                    NSArray *he = [DashboardB bg_findAll];
                    for (int i = 0; i<he.count; i++) {
                        DashboardB *dash =he[i];
                   if ([dash.bg_id integerValue] == id ) {
                            DLog(@"orignx%ld",(long)dash.bg_id);
                    dash.orignx = [NSNumber numberWithFloat:orignx];
                    dash.origny = [NSNumber numberWithFloat:origny];
                    dash.orignwidth = [NSNumber numberWithFloat:width];
                    dash.orignheight = [NSNumber numberWithFloat:height];
                       [dash bg_saveOrUpdate];
                        }
                    }
                }
                    break;
                case 3:
                {
                    NSArray *he = [DashboardC bg_findAll];
                    for (int i = 0; i<he.count; i++) {
                        DashboardC *dash =he[i];
                        
                        if ([dash.bg_id integerValue] == id ) {
                            DLog(@"orignx%ld",(long)dash.bg_id);
                    dash.orignx = [NSNumber numberWithFloat:orignx];
                    dash.origny = [NSNumber numberWithFloat:origny];
                    dash.orignwidth = [NSNumber numberWithFloat:width];
                    dash.orignheight = [NSNumber numberWithFloat:height];
                    dash.Gradientradius = [NSNumber numberWithFloat:width/2];
                    [dash bg_saveOrUpdate];
                }
                    }
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
- (void)startAnimationView{
    
    //自定义模式
    for (int i = 0; i<_CustomNumberArray.count; i++) {
        _PreNumberStr = _CustomNumberArray[i];
        [self initWithData];
        if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
            NSArray *arr = @[@"BG_ID",@"=",[NSNumber numberWithInteger: i+1]];
            NSArray *all = [CustomDashboard bg_findWhere:arr];
            for(CustomDashboard *dashboard in all){
                switch (dashboard.dashboardType) {
                    case 1:
                    {
                        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleAViewTag",_CustomNumberArray[i],@"StyleAViewnumber",_PreNumberStr,@"PreStyleAViewnumber", nil];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
                    }
                        break;
                    case 2:
                    {
                        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleBViewTag",_CustomNumberArray[i],@"StyleBViewnumber",_PreNumberStr,@"PreStyleBViewnumber", nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"StyleBupdateNumber" object:nil userInfo:dict];
                    }
                        break;
                    case 3:
                    {
                        dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:i+1];
                        dashboardStyleCView.NumberLabel.text = _CustomNumberArray[i];
                    }
                        break;
                    default:
                        break;
                }
                
            }
            
            
        }else{
            //经典模式
            switch ([DashboardSetting sharedInstance].dashboardStyle) {
                case DashboardStyleOne:
                {
                    
                    
                    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleAViewTag",_numberArray[i],@"StyleAViewnumber",_PreNumberStr,@"PreStyleAViewnumber", nil];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNumber" object:nil userInfo:dict];
                    
                }
                    break;
                case DashboardStyleTwo:
                {
                    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i+1],@"StyleBViewTag",_numberArray[i],@"StyleBViewnumber",_PreNumberStr,@"PreStyleBViewnumber", nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"StyleBupdateNumber" object:nil userInfo:dict];
                }
                    break;
                case DashboardStyleThree:
                {
                    dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:i+1];
                    dashboardStyleCView.NumberLabel.text = _numberArray[i];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)initWithData{
    _LabelNameArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];

    self.numberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];
    _CustomLabelArray = [[NSMutableArray alloc]initWithObjects:@"MPH",@"RPM",@"Engine Temp",@"MAF",@"Fuel rate",@"Battery",@"Battery",@"Battery",@"Battery", nil];
    
    self.CustomNumberArray = [[NSMutableArray alloc]initWithObjects:@"15",
                        @"19",@"34",@"23",@"54",@"34",@"23",@"54",@"23",@"43", nil];

   
    NSArray *pAllCount = [CustomDashboard bg_findAll];
    CustomDashboard *modle = pAllCount.lastObject;
    NSInteger space =   [modle.bg_id integerValue]  - _CustomLabelArray.count;
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
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    switch ([DashboardSetting sharedInstance].dashboardMode) {
        case DashboardClassicMode:
        {
            [DashboardSetting sharedInstance].KPageNumer = 3;
        }
            break;
        case DashboardCustomMode:
        {
            [DashboardSetting sharedInstance].KPageNumer = 4;
        }
            break;
    
        default:
            break;
    }
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
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
            [self initWithcustomMode];
        if ([DashboardSetting sharedInstance].isAddDashboard == YES) {
            [self addDashboard];
            [DashboardSetting sharedInstance].isAddDashboard = NO;
        }
        [self moveFoneView];

    }else{
        switch ([DashboardSetting sharedInstance].dashboardStyle) {
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
        [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self RemoveDisplay];
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    
}
- (void)back{
   
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    DLog(@"停止停止");
       [self stopSend];
   });
   [editview hide];
    ViewController *vc = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)stopSend{
    DLog(@"停止停止");
   self.blueTooth.stopSend = YES;
}
- (void)initWithcustomMode{
    
    NSArray* pAllCount = [CustomDashboard bg_findAll];
    for (NSInteger i = 0;i<pAllCount.count;i++) {
        CustomDashboard *dash = pAllCount[i];
        DLog(@"orignx%@--%@",dash.bg_id,dash.dashboardA.orignx);
        if (dash.dashboardType == 1) {
      
            dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.dashboardA.orignx doubleValue], [dash.dashboardA.origny doubleValue], [dash.dashboardA.orignwidth doubleValue], [dash.dashboardA.orignheight doubleValue])];
            [self initWithCustomDashboardAFrame:dash];
        }
        if (dash.dashboardType == 2){
            dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.dashboardB.orignx doubleValue], [dash.dashboardB.origny doubleValue], [dash.dashboardB.orignwidth doubleValue], [dash.dashboardB.orignheight doubleValue])];
            dashboardStyleBView.tag =[dash.bg_id integerValue];
            [dashboardStyleBView initWithModel:dash.dashboardB];
            DashBoardTag = dashboardStyleBView.tag ;
            dashboardStyleBView.delegate =self;
            dashboardStyleBView.PIDLabel.text = _CustomLabelArray[DashBoardTag-1];
            dashboardStyleBView.NumberLabel.text = _CustomNumberArray[DashBoardTag-1];
            dash.dashboardB.infoLabeltext = dashboardStyleBView.PIDLabel.text;
            [dash bg_saveOrUpdate];
            [scrollView addSubview:dashboardStyleBView];
            [self MoveDashboard: dashboardStyleBView.tag];
        }
        if (dash.dashboardType == 3){
            dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.dashboardC.orignx doubleValue], [dash.dashboardC.origny doubleValue], [dash.dashboardC.orignwidth doubleValue], [dash.dashboardC.orignheight doubleValue])];
            dashboardStyleCView.tag = [dash.bg_id integerValue] ;
            [dashboardStyleCView initWithModel:dash.dashboardC];
            DashBoardTag = dashboardStyleCView.tag ;
            dashboardStyleCView.delegate = self;
            dashboardStyleCView.PIDLabel.text = _CustomLabelArray[DashBoardTag-1];
            dashboardStyleCView.NumberLabel.text = _CustomNumberArray[DashBoardTag-1];
            dash.dashboardC.infoLabeltext = dashboardStyleCView.PIDLabel.text;
            [dash bg_saveOrUpdate];
            [scrollView addSubview:dashboardStyleCView];
            [self MoveDashboard: dashboardStyleAView.tag];
        }
    }
}

#pragma mark 初始化仪表盘风格
- (void)initWithStyleA{
    DashBoardTag = 0;
    NSArray* pAllCount = [DashboardA bg_findAll];
            for (DashboardA *dash in pAllCount) {
                DLog(@"总共%@,orignx=%f",dash.bg_id, [dash.orignx doubleValue]);
                dashboardStyleAView = [[DashboardView alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
                [self initwithDashboardAFrame:dash];
            }
}


- (void)initWithStyleB{
    DashBoardTag = 0;
    NSArray* pAllCount = [DashboardB bg_findAll];
    for (DashboardB *dash in pAllCount) {
        DLog(@"总共%@",dash.bg_id);
        DLog(@"_LabelNameArray%@",_LabelNameArray);
        
        dashboardStyleBView = [[DashboardViewStyleB alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
        [dashboardStyleBView initWithModel:dash];
        dashboardStyleBView.tag = [dash.bg_id integerValue] ;
        DashBoardTag = dashboardStyleBView.tag ;
        dashboardStyleBView.delegate = self;
        dashboardStyleBView.PIDLabel.text = _LabelNameArray[DashBoardTag-1];
        dashboardStyleBView.NumberLabel.text = _numberArray[DashBoardTag-1];
        dash.infoLabeltext = dashboardStyleBView.PIDLabel.text;
        [dash bg_saveOrUpdate];
        [scrollView addSubview:dashboardStyleBView];
    }
   
}


- (void)initWithStyleC{
    DashBoardTag = 0;
    NSArray* pAllCount = [DashboardC bg_findAll];
    for (DashboardC *dash in pAllCount) {
      
        
        dashboardStyleCView = [[DashboardViewStyleC alloc]initWithFrame:CGRectMake([dash.orignx doubleValue], [dash.origny doubleValue], [dash.orignwidth doubleValue], [dash.orignheight doubleValue])];
        dashboardStyleCView.tag = [dash.bg_id integerValue];
        [dashboardStyleCView initWithModel:dash];
        DashBoardTag = dashboardStyleCView.tag ;
        dashboardStyleCView.delegate = self;
        dashboardStyleCView.PIDLabel.text = _LabelNameArray[DashBoardTag-1];
        dashboardStyleCView.NumberLabel.text = _numberArray[DashBoardTag-1];
        dash.infoLabeltext = dashboardStyleCView.PIDLabel.text;
        [scrollView addSubview:dashboardStyleCView];
        [dash bg_saveOrUpdate];
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
    editview = [[editDashboardsView alloc]initWithFrame:CGRectMake(85*MSWidth/375, 50, MSWidth -85*MSWidth/375 , 240)];
    editview.delegate = self;
    [editview show];
}

- (void)scrollViewtap{
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
            if ([DashboardSetting sharedInstance].dashboardMode == DashboardClassicMode) {
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
       if ([DashboardSetting sharedInstance].dashboardMode == DashboardCustomMode) {
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
    NSArray *arr = @[@"BG_ID",@"=",[NSNumber numberWithInteger: sender.view.tag]];
    NSArray *all = [CustomDashboard bg_findWhere:arr];
    
    for(CustomDashboard *dashboard in all){
        switch (dashboard.dashboardType) {
            case 1:
            {
                [self updateCustomType:1 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
                break;
            case 2:
            {
                [self updateCustomType:2 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
                break;
            case 3:
            {
                [self updateCustomType:3 OrignX:orignx OrignY:origny Width:width Height:height ID:sender.view.tag];
            }
                break;
            default:
                break;
        }
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
            switch ([DashboardSetting sharedInstance].dashboardMode) {
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
//    [DashboardA bg_drop];
//    [DashboardB bg_drop];
//    [DashboardC bg_drop];
    [CustomDashboard bg_drop];
//    [[DashboardSetting sharedInstance] initWithdashboardA];
//    [[DashboardSetting sharedInstance] initWithdashboardB];
//    [[DashboardSetting sharedInstance] initWithdashboardC];
    [[DashboardSetting sharedInstance] initwithCustomDashboard];

    [DashboardSetting sharedInstance].KPageNumer = 4;
    [self clearAllUserDefaultsData];
    [self  updateView];
   
    
}
#pragma mark 使仪表盘移动到最前面
- (void)moveFoneView{
   
    //让仪表盘到最前面
    if ([DashboardSetting sharedInstance].isDashboardFont == YES ) {
        DLog(@"CCqianm");

        NSArray *arr = @[@"BG_ID",@"=",[NSNumber numberWithInteger: [DashboardSetting sharedInstance].Dashboardindex]];
        NSArray *all = [CustomDashboard bg_findWhere:arr];
        
        for(CustomDashboard *dashboard in all){
            
            switch (dashboard.dashboardType) {
                case 1:
                {
                    DashboardView *view = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                    [[view superview] bringSubviewToFront:view];
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
            [DashboardSetting sharedInstance].isDashboardFont = NO;
    }
    }
}
#pragma mark 点击移动仪表盘，让它变颜色；
- (void)MoveDashboard:(NSInteger)indexTag{
    //让仪表盘移动
    if ([DashboardSetting sharedInstance].Dashboardindex == indexTag &&  [DashboardSetting sharedInstance].isDashboardMove == YES ) {
        DLog(@"CCC");
        scrollView.scrollEnabled = NO;
        NSArray *arr = @[@"BG_ID",@"=",@([DashboardSetting sharedInstance].Dashboardindex)];
        NSArray *all = [CustomDashboard bg_findWhere:arr];    
        for(CustomDashboard *dashboard in all){
            
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

}

#pragma mark 点击添加
- (void)addDashboard{
    DLog(@"点击添加one,%ld",(long)[DashboardSetting sharedInstance].CurrentPage );
    DLog(@"点击,%ld",(long)[DashboardSetting sharedInstance].addStyle );

    
    switch ([DashboardSetting sharedInstance].addStyle) {
        case AddStyleOne:
        {
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleOne withTag:0];
            
            dashboardStyleAView = [[DashboardView alloc ]initWithFrame:CGRectMake([DashboardSetting sharedInstance].CurrentPage *MSWidth +(arc4random() % (int)200), (arc4random() % (int)300), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleAView.tag = ++ DashBoardTag;
            dashboardStyleAView.delegate =self;
            DLog(@"插入插入%ld",(long)dashboardStyleAView.tag);
         NSArray* pAll = [CustomDashboard bg_findAll];
             for(CustomDashboard *dashboard in pAll){
                 DLog(@"插入dashboarddashboard%@",dashboard);
                if ([dashboard.bg_id integerValue] == dashboardStyleAView.tag) {
                    DLog(@"插入插入");
                    [dashboardStyleAView addGradientView:dashboard.dashboardA.outerColor GradientViewWidth:dashboardStyleAView.frame.size.width];
                    [dashboardStyleAView initWithModel:dashboard.dashboardA];
                    [scrollView addSubview:dashboardStyleAView];
                }
             }
            [self updateCustomType:1 OrignX:dashboardStyleAView.frame.origin.x OrignY:dashboardStyleAView.frame.origin.y Width:dashboardStyleAView.frame.size.width Height:dashboardStyleAView.frame.size.height ID:dashboardStyleAView.tag];
            
            
         }
            break;
        case AddStyleTwo:
        {
            
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleTwo withTag:0];
         
            dashboardStyleBView = [[DashboardViewStyleB alloc ]initWithFrame:CGRectMake([DashboardSetting sharedInstance].CurrentPage*MSWidth+(arc4random() % (int)200), (arc4random() % (int)300 ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleBView.tag = ++ DashBoardTag;
            dashboardStyleBView.delegate =self;
             NSArray* pAll = [CustomDashboard bg_findAll];
             for(CustomDashboard *dashboard in pAll){
            if ([dashboard.bg_id  integerValue]== dashboardStyleBView.tag) {
                [dashboardStyleBView initWithModel:dashboard.dashboardB];
                [scrollView addSubview:dashboardStyleBView];
            }
             }
            [self updateCustomType:2 OrignX:dashboardStyleBView.frame.origin.x OrignY:dashboardStyleBView.frame.origin.y Width:dashboardStyleBView.frame.size.width Height:dashboardStyleBView.frame.size.height ID:dashboardStyleBView.tag];
        }
            break;
        case AddStyleThree:
        {
            [[DashboardSetting sharedInstance]CustomDashboardType:AddStyleThree withTag:0];

            dashboardStyleCView = [[DashboardViewStyleC alloc ]initWithFrame:CGRectMake( [DashboardSetting sharedInstance].CurrentPage*MSWidth +(arc4random() % (int)200), (arc4random() % (int)300 ), 150*KFontmultiple, 150*KFontmultiple)];
            dashboardStyleCView.tag = ++ DashBoardTag;
            dashboardStyleCView.delegate = self;
             NSArray* pAll = [CustomDashboard bg_findAll];
             for(CustomDashboard *dashboard in pAll){
            if ([dashboard.bg_id integerValue] == dashboardStyleCView.tag) {
                [dashboardStyleCView initWithModel:dashboard.dashboardC];
                [scrollView addSubview:dashboardStyleCView];
            [scrollView addSubview:dashboardStyleCView];
            }
             }
             [self updateCustomType:3 OrignX:dashboardStyleCView.frame.origin.x OrignY:dashboardStyleCView.frame.origin.y Width:dashboardStyleCView.frame.size.width Height:dashboardStyleCView.frame.size.height ID:dashboardStyleCView.tag];
        }
            break;
            
        default:
            break;
    }
    
    NSArray *dash = [CustomDashboard bg_findAll];
    for (CustomDashboard *model in dash) {
        DLog(@"主键逐渐%@",model.bg_id);
    }
    
}
#pragma mark 点击移除
- (void)RemoveDisplay{
     [[DashboardSetting sharedInstance].defaults setInteger:[[DashboardSetting sharedInstance].defaults integerForKey:@"AddDashboardNumber"]-1 forKey:@"AddDashboardNumber"];
    
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    NSArray *arr = @[@"bg_id",@"=",[NSNumber numberWithInteger: [DashboardSetting sharedInstance].Dashboardindex]];
    NSArray *all = [CustomDashboard bg_findWhere:arr];
    for(CustomDashboard *dashboard in all){
        switch (dashboard.dashboardType) {
            case 1:
            {
                dashboardStyleAView = (DashboardView *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                DLog(@"bg_id%@",dashboard.bg_id);
                
                [CustomDashboard bg_deleteAsync:arr complete:^(BOOL isSuccess) {
                    DLog(@"删除成功");
                  
                }];
                 [dashboardStyleAView removeFromSuperview];
              
            }
                break;
            case 2:
            {
                dashboardStyleBView = (DashboardViewStyleB *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [CustomDashboard bg_deleteWhere:arr];
                [dashboardStyleBView removeFromSuperview];

            }
                break;
            case 3:
            {
                dashboardStyleCView = (DashboardViewStyleC *)[scrollView viewWithTag:[DashboardSetting sharedInstance].Dashboardindex];
                [CustomDashboard bg_deleteWhere:arr];
                [dashboardStyleCView removeFromSuperview];
            }
                break;
            default:
                break;
        }    }
    
    NSArray *dash = [CustomDashboard bg_findAll];
    for (CustomDashboard *model in dash) {
        DLog(@"主键逐渐%@",model.bg_id);
    }
  
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
       scrollView.scrollEnabled = YES;
        [DashboardSetting sharedInstance].isDashboardMove = NO;
    NSArray *arr = @[@"bg_id",@"=",[NSNumber numberWithInteger:[DashboardSetting sharedInstance].Dashboardindex]];
    NSArray *all = [CustomDashboard bg_findWhere:arr];
    for(CustomDashboard *dashboard in all){
        switch (dashboard.dashboardType) {
            case 1:
            {
                DLog(@"111");
                dashboard.dashboardA.orignx = [NSNumber numberWithFloat:centerX];
                dashboard.dashboardA.origny = [NSNumber numberWithFloat:WithcenterY];
               
                    }
                break;
            case 2:
            {
                dashboard.dashboardB.orignx = [NSNumber numberWithFloat:centerX];
                dashboard.dashboardB.origny = [NSNumber numberWithFloat:WithcenterY];
            }
                break;
            case 3:
            {
                dashboard.dashboardC.orignx = [NSNumber numberWithFloat:centerX];
                dashboard.dashboardC.origny = [NSNumber numberWithFloat:WithcenterY];
            }
                break;
            default:
                break;
        }
        //更新为当前的数据
        [dashboard bg_updateWhere:arr];
        
    }
    
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
    [DashboardSetting sharedInstance].dashboardMode = DashboardCustomMode;
     [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleOne;
     [DashboardSetting sharedInstance].numberDecimals = NumberDecimalZero;
     [DashboardSetting sharedInstance].multiplierType = MultiplierType1;
     [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToNormal;
     [DashboardSetting sharedInstance].KPageNumer = 3;
     [DashboardSetting sharedInstance].isDashboardRemove = NO;
    [self LoadUI];
}
@end
