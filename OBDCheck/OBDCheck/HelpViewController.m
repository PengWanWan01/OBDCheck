//
//  HelpViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/23.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBarTitle:@"帮助" andLeftItemImageName:@"back" andRightItemName:@""];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"连接设备",@"仪表盘设置",@"故障码",@"问题反馈", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
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
    cell.textLabel.text =  self.dataSource[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
 
}

@end
