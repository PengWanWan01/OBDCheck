//
//  ConnectionController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ConnectionController.h"
#import "UIViewController+NavBar.h"

@interface ConnectionController ()

@end

@implementation ConnectionController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Connection" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithData];
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


- (void)initWithData{
    self.dataSource = [[NSMutableArray alloc
                        ]initWithObjects:@"连接的设备",@"连接方法",@"后台连接",@"OBD-II协议", nil];
}
- (void)initWithUI{
    
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
    cell.textLabel.text = self.dataSource[indexPath.row];
    if (indexPath.row == 2) {
        UISwitch *selectSwitch = [[UISwitch alloc]init];
        selectSwitch.on = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"backConnect"];
        [selectSwitch addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = selectSwitch;
    }else{
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)select:(UISwitch *)btn{
    if (btn.on == YES) {
        [UserDefaultSet sharedInstance].backConnect = backgroundConnectON;
    }else{
        [UserDefaultSet sharedInstance].backConnect = backgroundConnectOFF;
    }
    [[UserDefaultSet sharedInstance] SetIntegerAttribute:[UserDefaultSet sharedInstance].backConnect Key:@"backConnect"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            {
                
            }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}
@end
