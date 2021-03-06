//
//  SetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SetViewController.h"
#import "UIViewController+NavBar.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
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
    tableview.frame = CGRectMake(0, 1, SCREEN_MIN, SCREEN_MAX-TopHigh);
}
#pragma mark 横屏
- (void)setHorizontalFrame{
     tableview.frame = CGRectMake(0, 1, SCREEN_MAX, SCREEN_MIN-TopHigh);
}

- (void)initWithData{

    self.datasource = [[NSMutableArray alloc
                        ]initWithObjects:@"通信设置",@"单位设置",@"报警设置",@"通用设置",@"固件升级",@"关于", nil];
    
}
- (void)initWithUI{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, MSWidth, MSHeight-TopHigh) style:UITableViewStyleGrouped];
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
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSInteger result = 0;
//    if (section == 1) {
//        result = 5;
//    }else{
//        result = 1;
//    }
    return  self.datasource.count;
    
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
     cell.textLabel.text = _datasource[indexPath.row];
//    if (indexPath.section == 0) {
//        cell.textLabel.text = _datasource[indexPath.row];
//    }else if (indexPath.section == 1){
//         cell.textLabel.text = _datasource[indexPath.row+1];
//    }else{
//        cell.textLabel.text = _datasource[indexPath.row+4+indexPath.section ];
//    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            ConnectionController *vc = [[ConnectionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            UnitsController *vc = [[UnitsController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
//            switch (indexPath.row) {
//                case 0:
//                {
//                    informationController *vc = [[informationController alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
//                case 1:
//                {
//                    FirmwareController *vc = [[FirmwareController alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
//                case 2:
//                {
//                    ConnectionController *vc = [[ConnectionController alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;
//                case 3:
//                {
//
//                }
//                    break;
//                case 4:
//                {
//
//                }
//                    break;
//                default:
//                    break;
//            }
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
            GeneralController *vc = [[GeneralController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
