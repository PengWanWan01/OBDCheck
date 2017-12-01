//
//  SelectModeViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SelectModeViewController.h"

@interface SelectModeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *titleNameArray;
@end

@implementation SelectModeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards Mode" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [self initWithUI];
}

- (void)initWithUI{
    _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Classic Mode",@"Custom Mode", nil];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, _titleNameArray.count*44) style:UITableViewStylePlain];
    tableView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.scrollEnabled = NO;
    tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:tableView];
    
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
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleNameArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  _titleNameArray[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    cell.accessoryView = imageView;
    cell.accessoryView.hidden = YES;
    switch ([DashboardSetting sharedInstance].dashboardMode ) {
        case DashboardClassicMode:{
            if (indexPath.row == 0) {
                cell.accessoryView.hidden = NO;
            }
        }
            break;
        case DashboardCustomMode:{
            if (indexPath.row == 1) {
                cell.accessoryView.hidden = NO;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<_titleNameArray.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {
            cell.accessoryView.hidden = NO;
            switch (indexPath.row) {
                case 0:{  //经典模式
                    [DashboardSetting sharedInstance].dashboardMode = DashboardClassicMode;
                    [self clearAllUserDefaultsData];
                }
                    break;
                case 1:{  //自定义模式
                    [DashboardSetting sharedInstance].dashboardMode = DashboardCustomMode;
                }
                    break;
                default:
                    break;
        }
            NSLog(@"122,%ld",(long)[DashboardSetting sharedInstance].dashboardMode);

        }else{
            cell.accessoryView.hidden = YES;
        }
    }
}
- (void)clearAllUserDefaultsData
{
    
}
@end
