//
//  SetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    UIView *lineView ;
}
@property (nonatomic,strong) NSMutableArray *datasource;
@end

@implementation SetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Settings" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
        DLog(@"竖屏");
        [self setVerticalFrame];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        
        
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    tableview.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX-TopHigh);
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
}
#pragma mark 横屏
- (void)setHorizontalFrame{
     tableview.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN-TopHigh);
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
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
- (void)initWithData{

    self.datasource = [[NSMutableArray alloc
                        ]initWithObjects:@"Preferences",@"Information",@"Firmware Updates",@"Connection Help",@"License Agreement",@"Privacy Policy",@"Alarm settings",@"Feedback",@"Operation record", nil];
    
}
- (void)initWithUI{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    tableview.delegate = self;
    tableview.dataSource =  self;
  [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    if (section == 1) {
        result = 5;
    }else{
        result = 1;
    }
    return  result;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
     cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    if (indexPath.section == 0) {
        cell.textLabel.text = _datasource[indexPath.row];
    }else if (indexPath.section == 1){
         cell.textLabel.text = _datasource[indexPath.row+1];
    }else{
        cell.textLabel.text = _datasource[indexPath.row+4+indexPath.section ];
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            PreferencesController *vc = [[PreferencesController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    informationController *vc = [[informationController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    FirmwareController *vc = [[FirmwareController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    ConnectionController *vc = [[ConnectionController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            AlarmViewController *vc = [[AlarmViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            FeedbackViewController *vc = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
