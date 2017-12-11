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

    BOOL isSelect;
    NSInteger sendNumber;
    UIView *lineView;
}

@property (nonatomic,strong) NSMutableArray *btnTitleArray;
@property (nonatomic,strong) NSMutableArray *btnImageArray;
@property (nonatomic,strong) bluetoothView *blueView;
@property (nonatomic,strong) NSMutableArray *normalImage;
@property (nonatomic,strong) NSMutableArray *selectImage;
@property (nonatomic,strong) NSMutableArray *landNormalImage;
@property (nonatomic,strong) NSMutableArray *landSelectImage;
@property (nonatomic,strong) NSMutableArray *titleBtnData;
@property (nonatomic,strong)  UIImageView *statusView;
@property (nonatomic,strong)  UILabel  *statusLabel;
@property (nonatomic,strong)   UIImageView  *statusImageView;
@property (nonatomic,strong)  RLBtn * titleBtn;
@property (nonatomic,strong)  rotationView *roView;
@property (nonatomic,strong)  UIView *backView;
@property (nonatomic,strong)  UIScrollView *scrollView;
@property (nonatomic,strong)  UIView *tabarView;

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
    self.blueTooth = [BlueToothController Instance];
    self.blueTooth.delegate = self;
    [self initWithData];
    [self initWithUI];
   

}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
//        UIInterfaceOrientation
        NSLog(@"竖屏");
          [self setVerticalFrame];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
          NSLog(@"横屏");
        [self setHorizontalFrame];
      
        
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
//   lineView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height-1, self.navigationController.navigationBar.frame.size.width, 1);
    self.titleBtn.frame = CGRectMake(0, 0, 100, 44);
    self.statusView.frame = CGRectMake(22, 11, SCREEN_MIN - 44, 41);
    self.statusLabel.frame = CGRectMake(10, 0, SCREEN_MIN - 86, 40);
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusImageView.frame = CGRectMake(self.statusView.frame.size.width - 70, 10, 24, 20);
    self.roView.frame = CGRectMake(CGRectGetMaxX(self.statusView.frame) - 50, 10, 21, 23);
    self.backView.hidden = NO;
    self.scrollView.hidden = YES;
    [self.tabarView removeFromSuperview];
    self.tabarView =  [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_MAX - 49-TopHigh, SCREEN_MIN, 49)];
    if (IS_IPHONE_X) {
        self.tabarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh-34,SCREEN_MIN , 49);
    }
    [self.view addSubview:self.tabarView];
    //计算出底部按钮的最终字体大小；
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MIN/2-43*KFontmultiple, 49)];
    textLabel.text = @"Vehicle Information123";
    textLabel.adjustsFontSizeToFitWidth = YES;
    CGFloat textFont = textLabel.font.pointSize;
    NSLog(@"字体%f",textFont);
    //设置底部的两个按钮
    for (NSInteger i = 0; i< 2; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(SCREEN_MIN/2), 0,SCREEN_MIN/2 , 49)];
        if (IS_IPHONE_X) {
            btn.frame = CGRectMake(i*(SCREEN_MIN/2), 0,SCREEN_MIN/2 , 49);
        }
        btn.backgroundColor = [UIColor redColor];
        [btn setBackgroundImage: [UIImage imageNamed:_normalImage[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (i==0) {
            [btn setBackgroundImage: [UIImage imageNamed:_selectImage[i]] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(Selectbtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(43*KFontmultiple, 0, btn.frame.size.width-43*KFontmultiple, 49)];
        titleLabel.font = [UIFont ToAdapFont:16.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setText:_titleBtnData[i]];
        [titleLabel setTextColor:[ColorTools colorWithHexString:@"#1E2026"]];
        [btn addSubview:titleLabel];
        [self.tabarView addSubview:btn];
    }
}
#pragma mark 横屏
- (void)setHorizontalFrame{
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//     lineView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+rectStatus.size.height-1, self.navigationController.navigationBar.frame.size.width, 1);
    self.backView.hidden = YES;
    self.scrollView.hidden = NO;
    self.statusView.frame = CGRectMake(50, 16, SCREEN_MAX - 100, 41);
    self.statusLabel.frame =CGRectMake(10, 0, SCREEN_MAX - 100, 40);
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusView.image = [UIImage imageNamed:@"information"];
    self.statusView.contentMode = UIViewContentModeScaleToFill;
    self.statusImageView.frame = CGRectMake(SCREEN_MAX - 100 - 50, 10, 24, 20);
    self.roView.frame =CGRectMake(SCREEN_MAX - 100 - 50, 10, 24, 20);
    [self.tabarView removeFromSuperview];
    self.tabarView =  [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_MIN - 49-TopHigh, SCREEN_MAX, 49)];
    if (IS_IPHONE_X) {
        self.tabarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh-34,SCREEN_MAX , 49);
    }
    [self.view addSubview:self.tabarView];
    //计算出底部按钮的最终字体大小；
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MAX/2-139*KFontmultiple, 49)];
    textLabel.text = @"Vehicle Information123";
    textLabel.adjustsFontSizeToFitWidth = YES;
    CGFloat textFont = textLabel.font.pointSize;
    NSLog(@"字体%f",textFont);
    //设置底部的两个按钮
    for (NSInteger i = 0; i< 2; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(SCREEN_MAX/2), 0,SCREEN_MAX/2 , 49)];
        if (IS_IPHONE_X) {
            btn.frame = CGRectMake(i*(SCREEN_MAX/2), 0,SCREEN_MAX/2 , 49);
        }
        btn.backgroundColor = [UIColor redColor];
        [btn setBackgroundImage: [UIImage imageNamed:self.landNormalImage[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (i==0) {
            [btn setBackgroundImage: [UIImage imageNamed:self.landSelectImage[i]] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(Selectbtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(139*KFontmultiple, 0, btn.frame.size.width-139*KFontmultiple, 49)];
        titleLabel.font = [UIFont ToAdapFont:16.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setText:_titleBtnData[i]];
        [titleLabel setTextColor:[ColorTools colorWithHexString:@"#1E2026"]];
        [btn addSubview:titleLabel];
        [self.tabarView addSubview:btn];
    }
    
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

- (void)initWithUI{
    NSLog(@"大：%f",SCREEN_MAX);
    NSLog(@"小：%f",SCREEN_MIN);
    
//    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-1, self.navigationController.navigationBar.frame.size.width, 1)];
//    lineView.backgroundColor = [ColorTools colorWithHexString:@"#36373d"];
//    [self.navigationController.navigationBar addSubview:lineView];
//    [self.navigationController.navigationBar bringSubviewToFront:lineView];
    
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLog(@"竖屏");
        [self setVerticalFrame];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLog(@"横屏");
        [self setHorizontalFrame];
        
        
    }
    self.titleBtn= [[RLBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
     self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MSWidth - 86, 40)];
     self.statusLabel.font = [UIFont systemFontOfSize:16.f];
    if ([DashboardSetting sharedInstance].blueState == 1) {
        [self IsConnectState];
    }else{
        [self NonConnectState];
    }
    [self.titleBtn setTitle:@"Connect" forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.titleBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    [self.titleBtn addTarget:self action:@selector(LinkBlueTooth) forControlEvents:UIControlEventTouchUpInside];
    isSelect = YES;
    self.navigationItem.titleView = self.titleBtn;
    self.statusView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 11, MSWidth - 44, 41)];
    self.statusView.image = [UIImage imageNamed:@"information"];
    self.statusView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.statusView];
    self.statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.statusView.frame.size.width - 50, 10, 24, 20)];
    self.statusImageView.image = [UIImage imageNamed:@"signal"];
    self.statusImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.roView = [[rotationView alloc]initWithFrame:CGRectMake(self.statusView.frame.size.width - 50, 10, 21, 23)];
    [self.roView rotate360WithDuration:1 repeatCount:600];
    self.roView.rotationImage.image = [UIImage imageNamed:@"search"];
    self.roView.numberLabel.hidden = YES;
    if ([DashboardSetting sharedInstance].blueState == 1) {
        [self.roView removeFromSuperview];
        [self.statusView addSubview:self.statusImageView];
    }else{
        [self.statusImageView removeFromSuperview];
        [self.statusView addSubview:self.roView];
    }
    [self.statusView addSubview:self.statusLabel];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusView.frame), SCREEN_MIN, SCREEN_MAX - 165)];
    [self.view addSubview:self.backView];

    for (int i = 0; i<_btnTitleArray.count; i++) {
        CGFloat space = IS_IPHONE_4_OR_LESS?20*SCREEN_MAX/667:30*SCREEN_MAX/667;
        OBDBtn *btn =[[OBDBtn alloc]initWithFrame: CGRectMake([setDistanceUtil setX:i], [setDistanceUtil setY:i], 100*SCREEN_MIN/375, 100*SCREEN_MIN/375 + space)];
        btn.Label.text = _btnTitleArray[i];
        btn.imageView.image = [UIImage imageNamed:_btnImageArray[i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [btn addGestureRecognizer:tap];
      UIView *singleTapView  = [tap view];
        singleTapView.tag = i;
        [self.backView addSubview:btn];
        NSLog(@"%f",btn.frame.size.width);
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusView.frame) + 20, SCREEN_MAX, 100*SCREEN_MIN/375 + 40)];
    self.scrollView.backgroundColor = [UIColor blueColor];
    self.scrollView.contentSize = CGSizeMake(60+(100*SCREEN_MIN/375 + 40)*6,0);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    for (int i = 0; i<_btnTitleArray.count; i++) {
        OBDBtn *btn =[[OBDBtn alloc]initWithFrame: CGRectMake(30+(100*SCREEN_MIN/375 + 40)*i,0, 100*SCREEN_MIN/375 - 20, 100*SCREEN_MIN/375 - 20 +40)];
        btn.Label.text = _btnTitleArray[i];
        btn.imageView.image = [UIImage imageNamed:_btnImageArray[i]];
        [btn.imageView setContentMode:UIViewContentModeScaleToFill];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [btn addGestureRecognizer:tap];
        UIView *singleTapView  = [tap view];
        singleTapView.tag = i;
        [self.scrollView addSubview:btn];
        
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EveryViewtap)] ];
    
}

#pragma mark 底部按钮的点击事件
- (void)Selectbtn:(UIButton *)btn{
    [self.blueView hide];
    switch (btn.tag) {
        case 0:
        {
            ViewController *vc = [[ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 1:
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
    self.normalImage = [[NSMutableArray alloc]initWithObjects:@"OBD_normal",@"Vehicle_normal", nil];
    self.selectImage = [[NSMutableArray alloc]initWithObjects:@"OBD_highlight",@"Vehicle_highlight", nil];

    self.titleBtnData = [[NSMutableArray alloc]initWithObjects:@"OBD Features",@"Vehicle Information", nil];
    self.landNormalImage = [[NSMutableArray alloc]initWithObjects:@"OBD_normal_land",@"Vehicle_normal_land", nil];
    self.landSelectImage = [[NSMutableArray alloc]initWithObjects:@"OBD_highlight_land",@"Vehicle_highlight_land", nil];
    
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
            PerformancesViewController *vc = [[PerformancesViewController alloc]init];
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
       [ self.blueView show];
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
  
    if (!(info.discoveredPeripheral.name == nil)) {
     NSLog(@"得到的设备信息%@:%@",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
    NSMutableArray *data = [[NSMutableArray alloc]init];
    [data addObject:info.discoveredPeripheral.name];
   
    self.blueView= [[bluetoothView alloc]initWithFrame:CGRectMake(0, 64, MSWidth, 140)];
     self.blueView.dataSource = data;
   
    NSLog(@"得到数据%@",self.blueView.dataSource);
    }
}
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
    NSLog(@"收到收到%@",data);
    NSLog(@"转为：%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
    NSString *string = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"%@",string);
    if ([string isEqualToString:@"OK>"] && sendNumber ==0) {
        [self.blueTooth SendData:[BlueTool hexToBytes:@"41545350300D"]];
        ++sendNumber;
    }else if ([string isEqualToString:@"OK>"] && sendNumber ==1){
        [self.blueTooth SendData:[BlueTool hexToBytes:@"303130300D"]];
    }else if (string.length>21){
        if ([[string substringWithRange:NSMakeRange(0, 12)] isEqualToString:@"SEARCHING..."] && [[string substringWithRange:NSMakeRange(string.length -1 , 1)] isEqualToString:@">"]) {
            
        NSLog(@"可以发动了");
           [self IsConnectState];
//        SEARCHING...86F1114100FFFFFFFFC5>
        if ([[string substringWithRange:NSMakeRange(12, 6)] isEqualToString:@"86F111"]) {
            [DashboardSetting sharedInstance].protocolType = KWProtocol;
        }else if ([[string substringWithRange:NSMakeRange(12, 6)] isEqualToString:@"18DAF1"]){
            [DashboardSetting sharedInstance].protocolType = CanProtocol;
            }
        [self.blueTooth SendData:[BlueTool hexToBytes:@"415444500D"]];
    }
    }
}
-(void)NonConnectState{
    [DashboardSetting sharedInstance].blueState = 0;
    self.statusLabel.text = @"Please connect to the device...";
    [self.statusLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
    [self.titleBtn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
    [self.statusImageView removeFromSuperview];
    [self.statusView addSubview:self.roView];
    [self.roView rotate360WithDuration:1 repeatCount:600];
}
- (void)IsConnectState{
    [DashboardSetting sharedInstance].blueState = 1;
    [self.titleBtn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
    self.statusLabel.text = @"Connect to the device successfully";
    [self.statusLabel setTextColor:[ColorTools colorWithHexString:@"#FE9002"]];
    [self.roView removeFromSuperview];
    [self.statusView addSubview:self.statusImageView];
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
            [self NonConnectState];
            [self.blueView hide];
        }
            break;
        case BlueToothStateScan:
        {
            NSLog(@"搜索状态");
            [self NonConnectState];
            [self.blueView hide];
        }
            break;
        case BlueToothStateConnect:
        {
            NSLog(@"连接成功状态");
            sendNumber = 0;
            [self.blueTooth SendData:[BlueTool hexToBytes:@"415448310D"]];
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
