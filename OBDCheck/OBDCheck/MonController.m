//
//  MonController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "MonController.h"

@interface MonController ()<TBarViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    TBarView *tbarView;
    UIView *lineView;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation MonController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Montiors" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    lineView.frame = CGRectMake(0, 0, MSWidth, 0.5);
    self.tableView.frame = CGRectMake(0, 1, MSWidth, MSHeight-TopHigh) ;
    tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49);
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
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
- (void)initWithUI{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSWidth, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, MSWidth, MSHeight-TopHigh) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ResultsTableViewCell"];
    [self.tableView registerClass:[SummaryTableViewCell class] forCellReuseIdentifier:@"SummaryTableViewCell"];
    
    tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 49-TopHigh, MSWidth, 49)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 49-TopHigh-34,MSWidth ,49);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 0;
    tbarView.normalimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_normal",@"Sensor_normal",@"Mode06_normal",@"Mode09_normal",nil];
    tbarView.highimageData = [[NSMutableArray alloc]initWithObjects:@"monitor_highlight",@"Sensor_highlight",@"Mode06_highlight",@"Mode09_highlight",nil];
    tbarView.titleData = [[NSMutableArray alloc]initWithObjects:@"Monitor Tests",@"O2 Sensors",@"Mode $06",@"Mode $09", nil];
    tbarView.delegate = self;
    [tbarView initWithData];
    [self.view addSubview:tbarView];

}
- (void)TBarBtnBetouch:(NSInteger)touchSelectNumber{
    switch (touchSelectNumber) {
        case 0:
        {
            MonController *vc = [[MonController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            Sensors2ViewController *vc = [[Sensors2ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 2:
        {
            Mode06ViewController *vc = [[Mode06ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 3:
        {
            Mode09ViewController *vc = [[Mode09ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
    
}
- (void)back{
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    SummaryTableViewCell *Summarycell = [tableView dequeueReusableCellWithIdentifier:@"SummaryTableViewCell"];
    Summarycell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];

   ResultsTableViewCell *Resultcell = [tableView dequeueReusableCellWithIdentifier:@"ResultsTableViewCell"];
    Summarycell.selectionStyle = UITableViewCellSelectionStyleNone;
    Resultcell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    switch (indexPath.section) {
        case 0:
        {
            Summarycell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
            if (indexPath.row == 2 || indexPath.row == 3) {
                Summarycell.textLabel.text = @"MIL ON";
            }else{
                Summarycell.textLabel.numberOfLines = 0;
                Summarycell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",@"This vehcile is not ready for emissions",@"testing"];
            }
            if (indexPath.row == 0) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(MSWidth-32, 14, 22, 22)];
                image.image =[UIImage imageNamed:@"error"];
                Summarycell.accessoryView = image;
            }else{
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(MSWidth-32, 15, 24, 20)];
                image.image =[UIImage imageNamed:@"troubleCode_highLight"];
                Summarycell.accessoryView = image;
            }
            cell = Summarycell;
        }
            break;
        case 1:
        {
            cell = Resultcell;

        }
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
@end
