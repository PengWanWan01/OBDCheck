//
//  HUDViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/18.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HUDViewController.h"

@interface HUDViewController ()

@end

@implementation HUDViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initNavBarTitle:@"HUD" andLeftItemImageName:@"back" andRightItemImageName:@""];
     [self hideNavi];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationLandscapeRight;//横屏
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)initWithUI{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(MSHeight/2 - 1, 0, 1, MSWidth)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    for (NSInteger i = 0; i< 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (i +1) * (MSWidth/3), MSHeight, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:lineView];
    }
    UIView *FristView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSHeight/2 - 1, (MSWidth - 2)/3 )];
    [self.view addSubview:FristView];
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
        HUDView *View  = [[HUDView alloc]initWithFrame:CGRectMake(index * ((MSHeight/2)-1 ), page  * ( (MSWidth-2)/3), MSHeight/2, (MSWidth-2)/3)];
        [self.view addSubview:View];
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
//    NSTimer* timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(hideNavi) userInfo:nil repeats:NO];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Exit the HUD Mode" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlert];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
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
    NSLog(@"切换变成HUD模式");
    switch ([DashboardSetting sharedInstance].hudModeType) {
        case HUDModeTypeToHUD:{
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformScale(self.view.transform, -1, 1);
            self.view.transform = CGAffineTransformRotate( self.view.transform,M_PI);
            [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToNormal;
        }
            break;
        case HUDModeTypeToNormal:{
            self.view.transform = CGAffineTransformScale(self.view.transform, -1, 1);
            self.view.transform = CGAffineTransformRotate(self.view.transform, -M_PI);
            [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToHUD;

        }
            break;
        default:
            break;
    }
    
    
    
}

@end
