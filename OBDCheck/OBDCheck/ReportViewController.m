//
//  ReportViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/30.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()
@end

@implementation ReportViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Diagnostics3" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    
}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight-TopHigh-64);
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
}
- (void)initWithData{

    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Diagnostic Report",@"Monitor",@"Trouble Codes",@"Freeze Frame",@"Oxygen Sensors(Modes $05)",@"Om-Board Monitoring(Modes $06)",@"Vehicle Informantion(Modes $09)", nil];
   
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];

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
- (void)initWithUI{

}


-(void)back{

}
#pragma mark UITableViewDelegate,UITableViewDataSource
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
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }else{
        cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    }
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
