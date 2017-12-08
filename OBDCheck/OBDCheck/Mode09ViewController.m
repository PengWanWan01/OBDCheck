//
//  Mode09ViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/14.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "Mode09ViewController.h"

@interface Mode09ViewController ()<TBarViewDelegate>
{
    TBarView *tbarView ;
}
@end

@implementation Mode09ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Montiors" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
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
    self.tableView.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX-TopHigh) ;
    tbarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh, SCREEN_MIN, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh-34,SCREEN_MIN ,49);
    }
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN-TopHigh) ;
    tbarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh, SCREEN_MAX, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh-34,SCREEN_MAX ,49);
    }
}
- (void)initWithUI{
     [self.tableView registerNib:[UINib nibWithNibName:@"MonitorsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorsTableViewCell"];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 3;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_normal",@"Sensor_normal",@"Mode06_normal",@"Mode09_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_highlight",@"Sensor_highlight",@"Mode06_highlight",@"Mode09_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Monitor Tests",@"O2 Sensors",@"Mode $06",@"Mode $09", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
    
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            MonController *vc = [[MonController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            Sensors2ViewController *vc = [[Sensors2ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            Mode06ViewController *vc = [[Mode06ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 3:
        {
            Mode09ViewController *vc = [[Mode09ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
    
}
- (void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorsTableViewCell"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
@end
