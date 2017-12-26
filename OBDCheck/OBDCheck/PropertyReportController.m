//
//  PropertyReportController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PropertyReportController.h"

@interface PropertyReportController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *lineView ;
    UIView *headView;
}
@property (nonatomic,strong) NSMutableArray *showDataSource;
@property (nonatomic,strong) NSMutableArray *headDataSource;
@property (nonatomic,strong) NSMutableArray *detailDataSource;
@end

@implementation PropertyReportController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Report" andLeftItemImageName:@"back" andRightItemImageName:@" "];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initWithData];
    [self initWithHeadUI];
    [self initWithUI];
}
- (void)initWithData{
    self.showDataSource = [[NSMutableArray alloc]initWithObjects:@"0-100KM/H:",@"100km/h-0km/h:",@"0-100m:", nil];
    
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"0-100 km/h",@"Braking Distance",@"Braking Time",@"Max Speed",@"Max Acceleration",@"Peak Horsepower",@"0-100m time", nil];
    self.headDataSource = [[NSMutableArray alloc]initWithObjects:@"Acceleration Test ",@"Braking(100-0km/h)",@"Miscellaneous", nil];
    self.detailDataSource = [[NSMutableArray alloc]initWithObjects:self.model.reportSpeedUpTime,self.model.reportSpeedDownDistance,self.model.reportSpeedDownTime,self.model.reportMaxSpeed,self.model.reportMaxAcceleration,self.model.reportPeakHorsepower,self.model.reportUp100Time, nil];
    
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
    [self initWithHeadUI];
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    self.tableView.frame =  CGRectMake(0, 1, MSWidth, MSHeight-60);
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
        if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
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
- (void)initWithHeadUI{
    [headView removeFromSuperview];
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, TopHigh, MSWidth, 100)];
    [self.view addSubview:headView];
    UILabel *firstTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, MSWidth-20, 20)];
    firstTitle.textColor = [ColorTools colorWithHexString:@"918E8E"];
    firstTitle.text = @"Time/Max Speed";
    firstTitle.font = [UIFont systemFontOfSize:14.f];
    [headView addSubview:firstTitle];
    for (NSInteger i = 0; i<2; i++) {
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(MSWidth/2), CGRectGetMaxY(firstTitle.frame)+10, MSWidth/2, 30)];
        numberLabel.font = [UIFont systemFontOfSize:24.f];
        numberLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(MSWidth/2), CGRectGetMaxY(numberLabel.frame), MSWidth/2, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        if (i==0) {
            numberLabel.text = self.model.reportRunTime;
            titleLabel.text = @"Time";
        }else{
            numberLabel.text = self.model.reportMaxSpeed;
            titleLabel.text = @"Max Speed";
        }
        [headView addSubview:numberLabel];
        [headView addSubview:titleLabel];
    }
    self.tableView.tableHeaderView = headView;

}

- (void)initWithUI{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh-44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"212329"];
    [self.view addSubview:self.tableView];
    
//    for (int i = 0; i<3; i++) {//左边的三个内容
////        DLog(@"得到的数组%@",self.showDataSource);
//        UILabel *showLabel =[[UILabel alloc]initWithFrame: CGRectMake(0, CGRectGetMaxY(firstTitle.frame)+120+ i*40,MSWidth/2, 25)];
//        showLabel.text = self.showDataSource[i];
//        showLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
//        showLabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:showLabel];
//    }
//    NSArray *dataArray = [[NSArray alloc]initWithObjects:self.model.reportSpeedUpTime,self.model.reportSpeedDownDistance,self.model.reportUp100Time, nil];
//
//    for (int i = 0; i<3; i++) {//右边的三个内容
//        UILabel *showLabel =[[UILabel alloc]initWithFrame: CGRectMake(MSWidth/2, CGRectGetMaxY(firstTitle.frame)+120+ i*40,MSWidth/2, 25)];
//        showLabel.text = dataArray[i];
//        showLabel.textAlignment = NSTextAlignmentCenter;
//        showLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
//        [self.view addSubview:showLabel];
//    }
//
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result= 0 ;
    switch (section) {
        case 0:
            {
            result= 1;
            }
            break;
        case 1:
        {
            result= 2;
        }
            break;
        case 2:
        {
            result= 4;
        }
            break;
        default:
            break;
    }
    return  result;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 50)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, MSWidth-20, 20)];
    titileLabel.text = self.headDataSource[section];
    titileLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
    [headView addSubview:titileLabel];
    return headView;
    
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
    cell.detailTextLabel.textColor =  [ColorTools colorWithHexString:@"#C8C6C6"];
    switch (indexPath.section) {
        case 0:
            {
            cell.textLabel.text = self.dataSource[indexPath.row];
            cell.detailTextLabel.text = self.detailDataSource[indexPath.row];
            }
            break;
        case 1:
        {
            cell.textLabel.text = self.dataSource[indexPath.row+1];
              cell.detailTextLabel.text = self.detailDataSource[indexPath.row+1];
        }
            break;
        case 2:
        {
            cell.textLabel.text = self.dataSource[indexPath.row+3];
              cell.detailTextLabel.text = self.detailDataSource[indexPath.row+3];
        }
            break;
        default:
            break;
    }
    return cell;
}

@end
