//
//  TripsViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/8.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "TripsViewController.h"

@interface TripsViewController ()<TBarViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mytableView;
    TBarView *tbarView ;
    UIView *lineView ;
}
@property (nonatomic,strong) NSMutableArray *SectionHeadArray;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation TripsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Trips" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithUI];
}
- (void)initWithData{
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Distance",@"Fuel",@"Fuel Economy", nil];
    self.SectionHeadArray = [[NSMutableArray alloc]initWithObjects:@"Trip one",@"Trip two",@"Trip three",@"Trip four", nil];
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
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        //        UIInterfaceOrientation
        NSLog(@"竖屏");
        [self setVerticalFrame];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLog(@"横屏");
        [self setHorizontalFrame];
        
        
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    mytableView.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX-74-44);
    tbarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh, SCREEN_MIN, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, SCREEN_MAX - 49-TopHigh-34,SCREEN_MIN ,49);
    }
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    mytableView.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN-74-44);
    tbarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh, SCREEN_MAX, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, SCREEN_MIN - 49-TopHigh-34,SCREEN_MAX ,49);
    }
}
- (void)initWithUI{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
     mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-74-44) style:UITableViewStyleGrouped];
    mytableView.dataSource =self;
    mytableView.delegate = self;
    mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mytableView.separatorColor = [ColorTools colorWithHexString:@"212329"];
    mytableView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self.view addSubview:mytableView];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 3;
    tbarView.isSelectNumber = 1;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_normal",@"trips_normal",@"file_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"Graphs_highlight",@"trips_highlight",@"file_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Graphs",@"Trips",@"Files", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];
  
}
- (void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            LogsController *vc = [[LogsController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            TripsViewController *vc = [[TripsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            FilesViewController *vc = [[FilesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];//    [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 100, 20)];
    label.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    label.text = self.SectionHeadArray[section];
    [headView addSubview:label];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *FootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44.f)];
    FootView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];//    [ColorTools colorWithHexString:@"#212329"];
    UIButton *FootBtn = [[UIButton alloc]initWithFrame:CGRectMake((MSWidth/2) - 25, 14, 50, 20)];
    [FootBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [FootBtn setTitleColor:[ColorTools colorWithHexString:@"FE9002"] forState:UIControlStateNormal];
    [FootBtn addTarget:self action:@selector(FootBtn:) forControlEvents:UIControlEventTouchUpInside];
    FootBtn.tag = section;
    [FootView addSubview:FootBtn];
    return FootView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
  
    NSArray *arr= @[@"BG_ID",@"=",[NSNumber numberWithInteger:indexPath.section + 1]];
    NSArray* pAll = [TripsModel bg_findWhere:arr];
    for(TripsModel* model in pAll){
        switch (indexPath.row) {
            case 0:
            {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%@miles",model.distance];
            }
                break;
            case 1:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@gal",model.Fuel];

            }
                break;
            case 2:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@MPG",model.FuelEconmy];

            }
                break;
            default:
                break;
        }
    }
   
    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)FootBtn:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    TripsModel *model;
    NSString *SQL  = [NSString stringWithFormat:@"where pk = %ld",btn.tag+1];
    NSArray *pAll = [TripsModel bg_findWhere:SQL];
    for(TripsModel* logsmodel in pAll){
        NSLog(@"logsmodel.item1PID %d",logsmodel.bg_id  );
        model = logsmodel;
    }
    
    model.distance = @"0.00";
    model.Fuel = @"0.00";
    model.FuelEconmy = @"0.00";
//    [model bg_updateWhere:<#(NSArray * _Nullable)#>];
    
            [mytableView reloadData];


}
@end
