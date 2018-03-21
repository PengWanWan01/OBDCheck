//
//  AlarmViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/6.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "AlarmViewController.h"
#import "UIViewController+NavBar.h"

@interface AlarmViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *detialDatasource;
@end

@implementation AlarmViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Alarm settings" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initWithData];
}
- (void)initWithData{
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Alarm Switch",@"Speed Alarm",@"Water Temperature Alarm",@"Driver Fatigue Alarm", nil];
    NSString *SpeedAlarmStr = [NSString stringWithFormat:@"%@ km/h",[[Setting sharedInstance].defaults objectForKey:@"SpeedAlarm" ]];
      NSString *WaterTemperatureAlarm =  [NSString stringWithFormat:@"%@ ℃",[[Setting sharedInstance].defaults objectForKey:@"WaterTemperatureAlarm" ]];
  NSString *DriverFatigueAlarm = [NSString stringWithFormat:@"%@ h",[[Setting sharedInstance].defaults objectForKey:@"DriverFatigueAlarm" ]];
                                                                                              
    self.detialDatasource = [[NSMutableArray alloc]initWithObjects:SpeedAlarmStr,WaterTemperatureAlarm,DriverFatigueAlarm, nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"212329"];
    [self.view addSubview:self.tableView];
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    switch (section) {
        case 0:
            {
                result = 1;
            }
            break;
        case 1:
        {
            result = 3;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    switch (indexPath.section) {
        case 0:
            {
                cell.textLabel.text = self.dataSource[indexPath.row];
                UISwitch *selectSwitch = [[UISwitch alloc]init];
                selectSwitch.on = YES;
                cell.accessoryView = selectSwitch;
            }
            break;
        case 1:
        {
            cell.textLabel.text = self.dataSource[indexPath.row+1];
            cell.detailTextLabel.text = self.detialDatasource[indexPath.row];
            
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
//    if (cell.accessoryView.hidden == YES) {
//        cell.accessoryView.hidden = NO;
//    }else{
//        cell.accessoryView.hidden = YES;
//    }
    switch (indexPath.section) {
        case 0:
            {
                
            }
            break;
        case 1:
        {
            NSString *titleStr;
            NSString *reminderStr;
            switch (indexPath.row) {
                case 0:
                    {
                        titleStr = @"Speed Alarm";
                        reminderStr = @"Alarm when the Speed over the following values:";
                    }
                    break;
                case 1:
                {
                    titleStr = @"Water temperature Alarm";
                    reminderStr = @"When the water temperature over value alarm:";
                }
                    break;
                case 2:
                {
                    titleStr = @"Driver fatigue Alarm";
                    reminderStr = @"Alarm when driving longer than the following values:";
                }
                    break;
                default:
                    break;
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:reminderStr preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.delegate = self;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.tag = indexPath.row;
                [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   UITableViewCell * cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                switch (indexPath.row) {
                    case 0:
                        {
                        NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"SpeedAlarm"];
                         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ km/h",str];
                        }
                        break;
                    case 1:
                    {
                        NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"WaterTemperatureAlarm"];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ℃",str];
                    }
                        break;
                    case 2:
                    {
                        NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"DriverFatigueAlarm"];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ h",str];
                    }
                        break;
                    default:
                        break;
                }
            }]];
            
            [self presentViewController:alertController animated:true completion:nil];
        }
            break;
        default:
            break;
    }
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            {
                [[Setting sharedInstance].defaults setObject:textField.text forKey:@"SpeedAlarm"];
               
            }
            break;
        case 1:
        {
            [[Setting sharedInstance].defaults setObject:textField.text forKey:@"WaterTemperatureAlarm"];
          
        }
            break;
        case 2:
        {
              [[Setting sharedInstance].defaults setObject:textField.text forKey:@"DriverFatigueAlarm"];
        }
            break;
        default:
            break;
    }
}
@end
