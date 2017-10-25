//
//  ViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/7/31.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<BlueToothControllerDelegate>
{
    UIImageView *statusView;
    UILabel  *statusLabel;
    UIImageView  *statusImageView;
    BOOL isSelect;
    RLBtn * titleBtn;
}

@property (nonatomic,strong) NSMutableArray *btnTitleArray;
@property (nonatomic,strong) NSMutableArray *btnImageArray;
@property (nonatomic,strong) bluetoothView *blueView;
@property (nonatomic,strong) NSMutableArray *normalImage;
@property (nonatomic,strong) NSMutableArray *selectImage;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    [self setStatusBarBackgroundColor:[UIColor blackColor]];
     [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
     self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initNavBarTitle:@"" andLeftItemImageName:@"Upload" andRightItemImageName:@"help"];
   
    NSLog(@"IS_IPHONE%d,%f",IS_IPHONE,SCREEN_MAX_LENGTH);
    [self initWithData];
    [self initWithUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initWithUI{
    titleBtn= [[RLBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    if ([DashboardSetting sharedInstance].blueState == 1) {
        [titleBtn setTitleColor:[ColorTools colorWithHexString:@"#FE9002"] forState:UIControlStateNormal];
    }else{
     [titleBtn setTitleColor:[ColorTools colorWithHexString:@"#C8C6C6"] forState:UIControlStateNormal];
    }
    [titleBtn setTitle:@"Connect" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [titleBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(LinkBlueTooth) forControlEvents:UIControlEventTouchUpInside];
    isSelect = YES;
    self.navigationItem.titleView = titleBtn;
//    [ColorTools colorWithHexString:@"#212329"];
    statusView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 11, MSWidth - 44, 41)];
    statusView.image = [UIImage imageNamed:@"information"];
    statusView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:statusView];
    //CGRectGetMaxX(statusView.frame)
    statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(statusView.frame) - 50, 10, 24, 20)];
    statusImageView.image = [UIImage imageNamed:@"signal"];
    statusImageView.contentMode = UIViewContentModeScaleAspectFill;
    [statusView addSubview:statusImageView];
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MSWidth - 86, 40)];
    statusLabel.text = @"Connect to the device successfully";
    statusLabel.font = [UIFont systemFontOfSize:16.f];
    [statusLabel setTextColor:[ColorTools colorWithHexString:@"#FE9002"]];
    [statusView addSubview:statusLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame), MSWidth, MSHeight - 165)];
    [self.view addSubview:backView];
    
    for (int i = 0; i<_btnTitleArray.count; i++) {
    
        OBDBtn *btn =[[OBDBtn alloc]initWithFrame: CGRectMake([setDistanceUtil setX:i], [setDistanceUtil setY:i], 100*MSWidth/375, 100*MSWidth/375 + 30)];
        btn.Label.text = _btnTitleArray[i];
        btn.imageView.image = [UIImage imageNamed:_btnImageArray[i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [btn addGestureRecognizer:tap];
      UIView *singleTapView  = [tap view];
        singleTapView.tag = i;
        [backView addSubview:btn];
        NSLog(@"%f",btn.frame.size.width);
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EveryViewtap)] ];
    
    for (NSInteger i = 0; i< 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(MSWidth/3), MSHeight - 45*KHeightmultiple-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height,MSWidth/3 , 45*KHeightmultiple)];
        if (IS_IPHONE_X) {
             btn.frame = CGRectMake(i*(MSWidth/3), MSHeight - 45*KHeightmultiple-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height-34,MSWidth/3 , 45*KHeightmultiple);
        }
        [btn setBackgroundImage: [UIImage imageNamed:_normalImage[i]] forState:UIControlStateNormal];
        
        btn.tag = i;
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (i==0) {
            [btn setBackgroundImage: [UIImage imageNamed:_selectImage[i]] forState:UIControlStateNormal];
            
        }
        [btn addTarget:self action:@selector(Selectbtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
}
- (void)Selectbtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            ViewController *vc = [[ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            SpecialViewController *vc = [[SpecialViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            PersonalViewController *vc = [[PersonalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
}
-(void)initWithData{
    self.btnImageArray = [[NSMutableArray alloc]initWithObjects:@"Dashboards",@"Diagnostics",@"Montiors",@"Logs",@"Performance",@"Settings", nil];
    self.btnTitleArray = [[NSMutableArray alloc]initWithObjects:@"Dashboards",@"Diagnostics",@"Montiors",@"Logs",@"Performance",@"Settings", nil];
    self.normalImage = [[NSMutableArray alloc]initWithObjects:@"obd_normal",@"special_normal",@"personal_normal", nil];
    self.selectImage = [[NSMutableArray alloc]initWithObjects:@"obd_highlight",@"special_highlight",@"personal_highlight", nil];
    
    NSLog(@"%f",4*MSWidth/15 );
    
}
#pragma mark 整个屏幕的点击事件
- (void)EveryViewtap{

    [self.blueView hide];
}
#pragma mark 六个按钮的点击
- (void)tap:(UITapGestureRecognizer *)sender{
    NSLog(@"点击一个");
    [self.blueView hide];
 self.tabBarController.tabBar.hidden = YES;
    switch ([sender view].tag) {
        case 0:{
            DashboardController *vc = [[DashboardController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 1:{
            DiagController *vc = [[DiagController alloc]init];
           
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 2:{
            MonController *vc = [[MonController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 3:{
            LogsController *vc = [[LogsController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 4:{
            PerformanceController *vc = [[PerformanceController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 5:{
            SetViewController *vc = [[SetViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        default:
            break;
    }

}

- (void)back{
    NSLog(@"上传内容");
}
#pragma mark 点击连接蓝牙

- (void)LinkBlueTooth{
    if (isSelect) {
        NSLog(@"12");
        self.blueTooth = [BlueToothController Instance];
        self.blueTooth.delegate = self;
        isSelect = NO;
    }else{
        NSLog(@"13");
        [ self.blueView hide];
        isSelect = YES;
    }
}
#pragma mark 代理方法获取设备名称

//代理协议，处理信息
- (void)getDeviceInfo:(BELInfo *)info{
  
     NSLog(@"得到的设备信息%@:%@",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
    NSMutableArray *data = [[NSMutableArray alloc]init];
    [data addObject:info.discoveredPeripheral.name];
   
    self.blueView= [[bluetoothView alloc]initWithFrame:CGRectMake(0, 64, MSWidth, 140)];
     self.blueView.dataSource = data;
   
    NSLog(@"得到数据%@",self.blueView.dataSource);
}
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
    NSLog(@"收到收到%@",data);
    
    NSLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
   
  
    
}
#pragma mark 得到蓝牙连接状态
-(void)BlueToothState:(BlueToothState)state{
    NSLog(@"得到蓝牙连接的状态%lu",(unsigned long)state);
//    BlueToothStateDisScan = 0,          //停滞不搜索状态
//    BlueToothStateScan,                 //搜索状态
//    BlueToothStateConnect,
    switch (state) {
        case BlueToothStateDisScan:
        {
            NSLog(@"停滞不搜索状态");
        }
            break;
        case BlueToothStateScan:
        {
            NSLog(@"搜索状态");
        }
            break;
        case BlueToothStateConnect:
        {
            NSLog(@"连接成功状态");
            [DashboardSetting sharedInstance].blueState = 1;
            [titleBtn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
             [ self.blueView show];
        }
            break;
        default:
            break;
    }
}
- (UIImage*)imageCompressWithSimple:(UIImage*)image{
    CGSize size = image.size;
    CGFloat scale = 1.0;
    //TODO:KScreenWidth屏幕宽
    if (size.width > 100 || size.height > 100) {
        if (size.width > size.height) {
            scale = 100 / size.width;
        }else {
            scale = 100 / size.height;
        }
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    //TODO:设置新图片的宽高
    UIGraphicsBeginImageContext(secSize); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
