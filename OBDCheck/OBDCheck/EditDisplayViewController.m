//
//  EditDisplayViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "EditDisplayViewController.h"
#import "UIViewController+NavBar.h"

@interface EditDisplayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
}
@property (nonatomic,strong) NSMutableArray *titleNameArray;

@end

@implementation EditDisplayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Edit Display" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Dispaly Configuration",@"Style",@"Change Dashboard Style",@"Remove Display",@"Drag and Move",@"Bring to Font", nil];
    [self initWithUI];
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
    tableView.frame = CGRectMake(0, 34, SCREEN_MIN, SCREEN_MAX-TopHigh) ;
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    tableView.frame = CGRectMake(0, 34, SCREEN_MAX, SCREEN_MIN-TopHigh) ;
    
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
- (void)initWithUI{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.scrollEnabled = NO;
    tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:tableView];
    
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
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    if (indexPath.row==0 || indexPath.row ==1 || indexPath.row==2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            
        case 0:
        {
            DisplaySetViewController *vc = [[DisplaySetViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
            CustomDashboard *dashboard  = [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
            
            switch (dashboard.dashboardType) {
                case 1:
                {
                    StyleViewController *vc = [[StyleViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    StyleViewBController *vc = [[StyleViewBController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    StyleCViewController *vc = [[StyleCViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            [DashboardSetting sharedInstance].ischangeDashboard = YES;
            ChangeBoardStyleController *vc = [[ChangeBoardStyleController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:
        {
            [DashboardSetting sharedInstance].isDashboardRemove = YES;
            [self back];
            
        }
            break;
        case 4:
        {
            [DashboardSetting sharedInstance].isDashboardMove = YES;
            
            [self back];
        }
            break;
        case 5:
        {
            [DashboardSetting sharedInstance].isDashboardFont = YES;
            
            [self back];
            
        }
            break;
        default:
            break;
    }
}


@end

