//
//  HUDViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/18.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HUDViewController.h"
#import "UIViewController+NavBar.h"

@interface HUDViewController ()<BlueToothControllerDelegate>
{
    UILabel *NumberLabel;
    UILabel *PIDNameLabel;
    UILabel *UnitLabel;
    UIView *lineView;
    NSTimer* timer;
    UIView *PortraitBackView;
    UIView *landscapeBackView;

}
@property (nonatomic,strong) NSMutableArray *PIDDataSource;
@property (nonatomic,strong) NSMutableArray *NumberDataSource;
@property (nonatomic,strong) NSMutableArray *UnitDataSource;

@end

@implementation HUDViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initNavBarTitle:@"" andLeftItemImageName:@"back" andRightItemImageName:@"other"];
    [self hideNavi];
    [self initWithData];
    [self initWithUI];
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
        if (isLandscape) {
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
    PortraitBackView.hidden = NO;
    landscapeBackView.hidden = YES;
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    PortraitBackView.hidden = YES;
    landscapeBackView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"开始发送");
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    //发送车速
    [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];

}

- (void)initWithData{
    self.PIDDataSource = [[NSMutableArray alloc]initWithObjects:@"Speed",@"Rotational Speed",@"Average fuel consumption", nil];
     self.NumberDataSource = [[NSMutableArray alloc]initWithObjects:@"0",@"2500",@"7.6", nil];
    self.UnitDataSource = [[NSMutableArray alloc]initWithObjects:@"KM/H",@"R/MIN",@"L/100KM", nil];
    
}

- (void)initWithUI{
    [self initWithLandscapeUI];
    [self initWithPortraitUI];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
}
#pragma mark 竖屏
- (void)initWithPortraitUI
{
    PortraitBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX)];
    PortraitBackView.backgroundColor = [ColorTools colorWithHexString:@"212329"];

    [self.view addSubview:PortraitBackView];
    for (NSInteger i = 0; i<3; i++) {
//        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, i*(SCREEN_MAX/3), SCREEN_MIN, (SCREEN_MAX/3))];
//        [PortraitBackView addSubview:backView]
        HUDView *View  = [[HUDView alloc]initWithFrame:CGRectMake(0, i*(SCREEN_MAX/3), SCREEN_MIN, (SCREEN_MAX/3))];
        View.NumberLabel.textColor = [ColorTools colorWithHexString:[[UserDefaultSet sharedInstance]GetStringAttribute:@"HUDColourStr"]];
        View.PIDLabel.textColor = [ColorTools colorWithHexString:[[UserDefaultSet sharedInstance]GetStringAttribute:@"HUDColourStr"]];
        View.UnitLabel.textColor = [ColorTools colorWithHexString:[[UserDefaultSet sharedInstance]GetStringAttribute:@"HUDColourStr"]];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, View.frame.size.height, MSWidth, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [View addSubview:lineView];
        [PortraitBackView addSubview:View];

        
    }
    
    
}
#pragma mark 横屏
- (void)initWithLandscapeUI{
    landscapeBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN)];
    landscapeBackView.backgroundColor =  [ColorTools colorWithHexString:@"212329"];
    [self.view addSubview:landscapeBackView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_MAX/2 - 1, 0, 1, SCREEN_MIN)];
        lineView.backgroundColor = [UIColor whiteColor];
        [landscapeBackView addSubview:lineView];
        for (NSInteger i = 0; i< 2; i++) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (i +1) * (SCREEN_MIN/3), SCREEN_MAX, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
       [landscapeBackView addSubview:lineView];
        }
        UIView *FristView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MAX/2 - 1, (SCREEN_MIN - 2)/3 )];
        [landscapeBackView addSubview:FristView];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(FristView.frame.size.width/2 - 20, FristView.frame.size.height/2 - 22.5, 40, 45)];
        imageView.image = [UIImage imageNamed:@"HUDBtn"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *Clicktap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickToHUD:)];
          [imageView addGestureRecognizer:Clicktap];
        [FristView addSubview:imageView];
    
        for (NSInteger i = 1; i< 6; i++) {
            NSInteger index = i % 2;
            NSInteger page = i / 2;
            HUDView *View  = [[HUDView alloc]initWithFrame:CGRectMake(index * ((SCREEN_MAX/2)-1 ), page  * ( (SCREEN_MIN-2)/3), SCREEN_MAX/2, (SCREEN_MIN-2)/3)];
            View.NumberLabel.textColor = [ColorTools colorWithHexString:[[UserDefaultSet sharedInstance]GetStringAttribute:@"HUDColourStr"]];
            View.PIDLabel.textColor = [ColorTools colorWithHexString:[[UserDefaultSet sharedInstance]GetStringAttribute:@"HUDColourStr"]];
            View.UnitLabel.textColor = [ColorTools colorWithHexString:[[UserDefaultSet sharedInstance]GetStringAttribute:@"HUDColourStr"]];
            [landscapeBackView addSubview:View];
           }
    
    
}
#pragma mark 屏幕上的点击事件
- (void)tap{
    //弹出导航栏和状态栏
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //创建计时器，3秒之后收回导航栏
    timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(hideNavi) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}
- (void)back{
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonClick{
     [timer invalidate];
    HUDColorViewController *vc = [[HUDColorViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 隐藏导航栏和状态栏
- (void)hideNavi{
    //隐藏导航栏和状态栏
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
#pragma mark 确定退出HUD模式
- (void)showAlert{
    [self back];
//    DashboardController *vc = [[DashboardController alloc]init];
//    [self.navigationController pushViewController:vc animated:NO];
//    
}
#pragma mark 切换变成HUD模式
- (void)ClickToHUD:(UITapGestureRecognizer *)sender{
    DLog(@"切换变成HUD模式");
    switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"hudModeType"]) {
        case HUDModeTypeToHUD:{
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformScale(self.view.transform, -1, 1);
            self.view.transform = CGAffineTransformRotate( self.view.transform,M_PI);
            [UserDefaultSet sharedInstance].hudModeType = HUDModeTypeToNormal;
        }
            break;
        case HUDModeTypeToNormal:{
            self.view.transform = CGAffineTransformScale(self.view.transform, -1, 1);
            self.view.transform = CGAffineTransformRotate(self.view.transform, -M_PI);
            [UserDefaultSet sharedInstance].hudModeType = HUDModeTypeToHUD;

        }
            break;
        default:
            break;
    }
    
    [[UserDefaultSet sharedInstance]SetIntegerAttribute:[UserDefaultSet sharedInstance].hudModeType Key:@"hudModeType"];
    
}
#pragma mark 遵守蓝牙的协议
-(void)BlueToothState:(BlueToothState)state{
    
}
-(void)getDeviceInfo:(BELInfo*)info{
    
}
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
 
    DLog(@"收到收到%@",data);
    
    DLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
//    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    DLog(@"%@",string);
//    NSString *VehicleSpeedStr = [BlueTool isVehicleSpeed:string];
//    NSString *RotationalStr = [BlueTool isRotational:string];
//    NSString *WatertemperatureStr = [BlueTool isWatertemperature:string];
//    DLog(@"车速%@",VehicleSpeedStr);
//    DLog(@"转速%@",RotationalStr);
//    DLog(@"水温%@",WatertemperatureStr);
//    
//    if (!(VehicleSpeedStr == nil)) {
//        if (PIDNameLabel.tag == 0) {
//        PIDNameLabel.text = VehicleSpeedStr;
//        }
//        //得到车速之后，发送转速
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130630D"]];
//    }else{
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
//    }
//    if (!(RotationalStr == nil)) {
//        if (PIDNameLabel.tag == 1) {
//            PIDNameLabel.text = RotationalStr;
//        }
//        //发送水温
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130350D"]];
//        
//    }
//    if (!(WatertemperatureStr == nil)) {
//        if (PIDNameLabel.tag == 2) {
//            PIDNameLabel.text = WatertemperatureStr;
//        }
//        //得到水温之后，发送车速
//        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130640D"]];
//    }
   
    
}
@end
