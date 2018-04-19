//
//  GeneralController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "GeneralController.h"
#import "UIViewController+NavBar.h"

@interface GeneralController ()
@property (nonatomic,strong) NSMutableArray *detialdataSource;

@end

@implementation GeneralController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initNavBarTitle:@"GeneralSet" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"保持开启屏幕",@"是否显示小窍门提示框",@"启动后显示仪表页面",@"自动截图",nil];
    self.detialdataSource = [[NSMutableArray alloc]initWithObjects:@"120 km/h",@"110 ℃",@"3 h", nil];
    
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
    
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger reslut = 0;
  
    return self.dataSource.count;
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
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    if(indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        UISwitch *selectSwitch = [[UISwitch alloc]init];
        selectSwitch.on = [[UserDefaultSet sharedInstance]GetAttribute:@"backConnect"];
        selectSwitch.tag = indexPath.row;
        [selectSwitch addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = selectSwitch;
    }
//    switch (indexPath.section ) {
//        case 0:
//            {
//                cell.textLabel.text = self.dataSource[indexPath.row];
//                if (indexPath.row == 1) {
//                    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
//                    cell.detailTextLabel.text = @"USD";
//                    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
//                }
//            }
//            break;
//        case 1:
//        {
//            cell.textLabel.text = self.dataSource[indexPath.row+2];
//            if (!(indexPath.row == 0)) {
//                cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
//                cell.detailTextLabel.text = self.detialdataSource[indexPath.row-1];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    if (indexPath.row == 0) {
//        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//        swit.on = YES;
//        cell.accessoryView = swit;
//
//    }
    return cell;
}
- (void)select:(UISwitch *)btn{
    if (btn.on == YES) {
        switch (btn.tag) {
            case 0:
                {
                  [UserDefaultSet sharedInstance].keepScreen = keepScreenON;
                [[UserDefaultSet sharedInstance] SetAttribute:[UserDefaultSet sharedInstance].keepScreen Key:@"keepScreen"];
                }
                break;
            case 1:
            {
                [UserDefaultSet sharedInstance].keeptips = KeepTipsON;
                  [[UserDefaultSet sharedInstance] SetAttribute:[UserDefaultSet sharedInstance].keeptips Key:@"keeptips"];
            }
                break;
            case 2:
            {
                [UserDefaultSet sharedInstance].launchDashboard = LaunchDashboardON;
                  [[UserDefaultSet sharedInstance] SetAttribute:[UserDefaultSet sharedInstance].launchDashboard Key:@"launchDashboard"];
            }
                break;
            default:
                break;
        }
    }else{
        switch (btn.tag) {
            case 0:
            {
                [UserDefaultSet sharedInstance].keepScreen = keepScreenOFF;
                  [[UserDefaultSet sharedInstance] SetAttribute:[UserDefaultSet sharedInstance].keepScreen Key:@"keepScreen"];
            }
                break;
            case 1:
            {
                [UserDefaultSet sharedInstance].keeptips = KeepTipsOFF;
                 [[UserDefaultSet sharedInstance] SetAttribute:[UserDefaultSet sharedInstance].keeptips Key:@"keeptips"];
            }
                break;
            case 2:
            {
                [UserDefaultSet sharedInstance].launchDashboard = LaunchDashboardOFF;
                  [[UserDefaultSet sharedInstance] SetAttribute:[UserDefaultSet sharedInstance].launchDashboard Key:@"launchDashboard"];
            }
                break;
            default:
                break;
        }
    }

}
@end
