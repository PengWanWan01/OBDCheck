//
//  ReportViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/30.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<TBarViewDelegate>
{
    UIView *lineView ;
    TBarView *tbarView;
}
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
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
     tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight);
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
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 3;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_normal",@"freeze_normal",@"readiness_normal",@"report_normal", nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"troubleCode_highLight",@"Freeze_highlight",@"readiness_highLight",@"report_highLight", nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"trouble Codes",@"Freeze Frame",@"Readiness Test",@"Report", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    
    [self.view addSubview:tbarView];
}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            DiagController *vc = [[DiagController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            FreezeViewController *vc = [[FreezeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            ReadinessViewController *vc = [[ReadinessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 3:
        {
            ReportViewController *vc = [[ReportViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
}

-(void)back{

    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
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
