//
//  FirmwareController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FirmwareController.h"

@interface FirmwareController ()

@end

@implementation FirmwareController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Firmware Updates" andLeftItemImageName:@"back" andRightItemImageName:@""];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Firmware Version",@"Serial Number",@"Automatically check for updates", nil];
    
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
    
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    switch (section) {
        case 0:
            {
                result = 2;
            }
            break;
        case 1:
        {
          result = 1;
        }
            break;
        default:
            break;
    }
    return result;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    
    switch (indexPath.section) {
        case 0:
            {
                 cell.textLabel.text = self.dataSource[indexPath.row];
                  cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"918E8E"];
                switch (indexPath.row) {
                    case 0:
                        {
                            cell.detailTextLabel.text = @"1.0.0";
                        }
                        break;
                    case 1:
                    {
                        cell.detailTextLabel.text = @"201707190001";
                    }
                        break;
                    default:
                        break;
                }
            }
            break;
        case 1:
        {
          cell.textLabel.text = self.dataSource[indexPath.row+2];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
     if (section == 0) {
       label.text = @"OBDCHECK";
     }
    label.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    label.font = [UIFont boldSystemFontOfSize:14.f];
    [headView addSubview:label];
    return headView;
  
}
@end
