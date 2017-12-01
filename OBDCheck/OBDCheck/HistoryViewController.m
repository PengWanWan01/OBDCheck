//
//  HistoryViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource,TBarViewDelegate>
{
    UITableView *MYTableView;

}
@property (nonatomic,strong) NSMutableArray *sectiondatasource;
@end

@implementation HistoryViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"History Codes" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initwithdata];
    [self initWithUI];
}
- (void)initwithdata{
   
    _sectiondatasource = [[NSMutableArray alloc]init];
    NSArray *array = [troubleCodeModel bg_findAll];
//    troubleCodeModel *model =
    for (troubleCodeModel *model in array) {
        NSLog(@"%@%@",model.currentTime,model.toubleCode);
    }
    NSLog(@"array%@",array);
    [_sectiondatasource addObject:array];
    [self initWithtabUI];
}
- (void)initWithtabUI{
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 0;
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
    MYTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    MYTableView.backgroundColor = [ColorTools colorWithHexString:@"18191D"];
    MYTableView.delegate =self;
    MYTableView.dataSource =self;
    MYTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:MYTableView];
    [MYTableView registerNib:[UINib nibWithNibName:@"DiagnosticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiagnosticsTableViewCell"];

}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectiondatasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *carlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, MSWidth, 24.f)];
//    troubleCodeModel *model = self.sectiondatasource[section];
//    carlabel.text = model.currentTime;
    carlabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    carlabel.font = [UIFont boldSystemFontOfSize:14.f];
    [headView addSubview:carlabel];
    
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(MSWidth-100, 20, 100, 24.f)];
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timedata = [dateformatter stringFromDate:senddate];
    timelabel.text = timedata;
    timelabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    timelabel.font = [UIFont boldSystemFontOfSize:14.f];
    timelabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:timelabel];

    [headView addSubview:carlabel];

    return headView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiagnosticsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnosticsTableViewCell"];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    return Cell;
}

@end
