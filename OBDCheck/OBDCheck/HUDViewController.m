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
 
    UIView *lineView;
//    NSTimer* timer;

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
   [self initWithUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
 
    DLog(@"开始发送");
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    self.blueTooth.stopSend = NO;
    
    
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    for (NSInteger i = 0; i < 6; i++) {
        HUDView *view = (HUDView *)[self.view viewWithTag:i+10];
        NSInteger index = i % 2;
        NSInteger page = i / 2;
       view.frame =  CGRectMake(index * ((MSWidth/2) +2), page  * ( (MSHeight-TopHigh)/3), MSWidth/2, (MSHeight-TopHigh)/3 + 3);
        view.NumberLabel.frame =  CGRectMake(0, view.frame.size.height/3, view.frame.size.width, view.frame.size.height/3);
        view.PIDLabel.frame =  CGRectMake(13, 10, view.frame.size.width-26, view.frame.size.height/3 - 10);
        
        view.UnitLabel.frame = CGRectMake(13,2*view.frame.size.height/3, view.frame.size.width-26, view.frame.size.height/3);
        view.RightLine.frame = CGRectMake(view.frame.size.width - 2, 0, 1, view.frame.size.height);
        view.buttomLine.frame = CGRectMake(0, view.frame.size.height -1, view.frame.size.width, 1);
        if (isLandscape) {
            view.NumberLabel.font = [UIFont ToAdapFont:55.f];
//            view.NumberLabel.adjustsFontSizeToFitWidth = YES;
        }else{
            view.NumberLabel.font = [UIFont ToAdapFont:70.f];
        }
    }
    
}
#pragma mark 竖屏
- (void)setVerticalFrame{
  
}
#pragma mark 横屏
- (void)setHorizontalFrame{
  
}


- (void)initWithData{
    self.PIDDataSource = [[NSMutableArray alloc]initWithObjects:@"VSS",@"RPM",@"ECT",@"IAT",@"Batterry",@"EOT", nil];
     self.NumberDataSource = [[NSMutableArray alloc]initWithObjects:@"0",@"2500",@"7.6", nil];
    self.UnitDataSource = [[NSMutableArray alloc]initWithObjects:@"KM/H",@"R/MIN",@"L/100KM", nil];
    
}

- (void)initWithUI{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i<6; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        HUDView *View  = [[HUDView alloc]initWithFrame:CGRectMake(index * ((MSWidth/2)-1 ), page  * ( (MSHeight-TopHigh)/3), MSWidth/2, (MSHeight-TopHigh)/3)];
        View.tag = i+10;
        [self.view addSubview:View];
        View.PIDLabel.text = self.PIDDataSource[i];
        HUDSet *model =   [[OBDataModel sharedDataBase]findTable:@"HUDs" withID:i+1].lastObject;
        DLog(@"huoqu:%@ %@",model,model.NumberColor);
        View.NumberLabel.textColor = [ColorTools colorWithHexString:model.NumberColor];
        View.PIDLabel.textColor = [ColorTools colorWithHexString:model.PIDColor];
        View.UnitLabel.textColor = [ColorTools colorWithHexString:model.UnitColor];
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark 屏幕上的点击事件
- (void)tap{
//    //弹出导航栏和状态栏
//    self.navigationController.navigationBar.hidden = NO;
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    //创建计时器，3秒之后收回导航栏
//    timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(hideNavi) userInfo:nil repeats:NO];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}
- (void)back{
//    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonClick{
//     [timer invalidate];
    HUDSetViewController *vc = [[HUDSetViewController alloc]init];
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
