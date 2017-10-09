//
//  FileBackViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/28.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FileBackViewController.h"

@interface FileBackViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *LineView;
    UIScrollView *contentScrollView;
    NSInteger PIDNumber;
    LineChartView *chartViewone;
    LineChartView *chartViewtwo;
    UITableView *mytableView;
    FileInfoView *InfoView;

}
@property(nonatomic,strong)NSMutableArray *btnDatasource;
@property(nonatomic,strong)NSMutableArray *Datasource;
@property(nonatomic,strong)NSMutableArray *detailDatasource;


@end

@implementation FileBackViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initNavBarTitle:@"Files" andLeftItemImageName:@"back" andRightItemName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    PIDNumber = 3;
     [self initWithData];
    [self initWithTitleView];
}
- (void)initWithData{
    self.btnDatasource = [[NSMutableArray alloc]initWithObjects:@"Chart",@"Data", nil];
    self.Datasource = [[NSMutableArray alloc]initWithObjects:@"Beginning Time",@"End Time",@"Drive Time",@"Mileage",@"Fuel Cost",@"Charge",@"Max Speed",@"Average Speed",@"Overspeed Times",@"Overspeed Time",@"Idle Time",@"Score", nil];
    self.detailDatasource = [[NSMutableArray alloc]initWithObjects:@"2017-07-27 15:21:48",@"2017-07-27 15:21:48", @"00:00:00",@"0 Mile", @"0 G",@"0 USD", @"0 MPH",@"0 MPH",@"0",@"00:00:00", @"00:00:00",@"100",nil];
    
}
- (void)initWithTitleView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 40)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"101010"];
    [self.view addSubview:headView];
    for (NSInteger i = 0; i< 2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*MSWidth/2, 0, MSWidth/2, 40)];
        [btn setTitle:self.btnDatasource[i] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorTools colorWithHexString:@"C8C6C6"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    LineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, MSWidth/2, 2)];
      LineView.backgroundColor = [ColorTools colorWithHexString:@"FE9002"];
    [headView addSubview:LineView];
//添加UIScrollView内容
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, MSWidth*2, MSHeight)];
    contentScrollView.contentSize = CGSizeMake(MSWidth,MSHeight*2);
    contentScrollView.pagingEnabled = NO;
    [contentScrollView setShowsHorizontalScrollIndicator:NO];
//    [contentScrollView setShowsVerticalScrollIndicator:NO];
//    contentScrollView.backgroundColor  = [UIColor redColor];
    [self.view addSubview:contentScrollView];
    [self initWithChart];
    [self initWithDataUI];
    
}
- (void)initWithChart{
    //设置Time/Mileage的内容；
    FileInfoView *TimeView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 100)];
    TimeView.titileLabel.text = @"Time/Mileage";
    TimeView.leftNumberLabel.text = @"0:00:16";
    TimeView.leftNameLabel.text = @"Time";
    TimeView.rightNameLabel.text = @"Mileage";
    TimeView.rightNumberLabel.text = @"310km";
    [contentScrollView addSubview:TimeView];
    
    //设置Playback的内容
    UILabel *PlaybackLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(TimeView.frame)+30, MSWidth-15, 20)];
//    PlaybackLabel.backgroundColor = [UIColor redColor];
    PlaybackLabel.textColor = [ColorTools colorWithHexString:@"918E8E"];
    PlaybackLabel.text = @"Playback";
    [contentScrollView addSubview:PlaybackLabel];
    
    chartViewone = [[LineChartView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(PlaybackLabel.frame), MSWidth- 30, 180)];
    chartViewone.backgroundColor = [ColorTools colorWithHexString:@"101010"];
    [contentScrollView addSubview:chartViewone];
    if (PIDNumber>2) {
        chartViewtwo = [[LineChartView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(chartViewone.frame), MSWidth- 30, 180)];
        chartViewtwo.backgroundColor = [ColorTools colorWithHexString:@"101010"];
        [contentScrollView addSubview:chartViewtwo];
        InfoView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewtwo.frame), MSWidth, 100)];
    }else{
        InfoView = [[FileInfoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chartViewone.frame), MSWidth, 100)];
    }
    
    
    InfoView.titileLabel.text = @"Info";
    InfoView.leftNumberLabel.text = @"7.6 L/100km";
    InfoView.leftNameLabel.text = @"Average economy";
    InfoView.rightNumberLabel.text = @"78.6km/h";
    InfoView.rightNameLabel.text = @"Average Speed";
    [contentScrollView addSubview:InfoView];
}
- (void)initWithDataUI{
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth, 0, MSWidth, MSHeight-100) style:UITableViewStylePlain];
    mytableView.backgroundColor = [UIColor clearColor];
    mytableView.separatorInset = UIEdgeInsetsZero;
    mytableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    [contentScrollView addSubview:mytableView];
    [mytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];

}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Datasource.count;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.textLabel.text = self.Datasource[indexPath.row];
      cell.detailTextLabel.text = self.detailDatasource[indexPath.row];
    if (indexPath.row == self.Datasource.count - 1) {
        cell.textLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
        cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];

    }else{
        cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    }
    return cell;
    
}
- (void)btn:(UIButton *)btn{
    contentScrollView.contentOffset = CGPointMake(btn.tag*MSWidth, 0);
    switch (btn.tag) {
        case 0:
            {
            LineView.frame = CGRectMake(0, 38, MSWidth/2, 2);
                contentScrollView.scrollEnabled = YES;
            }
            break;
        case 1:
        {
           LineView.frame = CGRectMake(MSWidth/2, 38, MSWidth/2, 2);
            contentScrollView.scrollEnabled = NO;

        }
            break;
        default:
            break;
    }
    
}

@end
