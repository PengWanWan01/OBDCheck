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
    [self initNavBarTitle:@"报告" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight-TopHigh-64);
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
}
- (void)initWithData{

//    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Diagnostic Report",@"Monitor",@"Trouble Codes",@"Freeze Frame",@"Oxygen Sensors(Modes $05)",@"Om-Board Monitoring(Modes $06)",@"Vehicle Informantion(Modes $09)", nil];
   
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];

    [self initWithUI];
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
    return 15;
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
//    if (indexPath.row == 0) {
//        cell.backgroundColor = [UIColor clearColor];
//    }else{
    cell.backgroundColor = [[ColorTools colorWithHexString:@"#848487"]   colorWithAlphaComponent:0.37f];
 
//    }
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.textLabel.text = @"2018-04-16 19：00：23";
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportDetailController *vc = [[ReportDetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  刷新
- (void)rightBarButtonClick{
    DLog(@"刷新");
}

@end
