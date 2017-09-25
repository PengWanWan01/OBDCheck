//
//  ReadinessViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ReadinessViewController.h"

@interface ReadinessViewController ()<TBarViewDelegate>
@property(nonatomic,strong)NSMutableArray *completeDatasource;
@property(nonatomic,strong)NSMutableArray *UndfinishedDatasource;
@property(nonatomic,strong)NSMutableArray *NotsupportDatasource;

@end

@implementation ReadinessViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self initNavBarTitle:@"Diagnostics2" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
      [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    UIImageView *headimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 18, MSWidth, 20)];
    headimageView.image = [UIImage imageNamed:@"ReadinessbackView"];
    headimageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:headimageView];
    self.tableView.frame = CGRectMake(0, 38, MSWidth, MSHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}
- (void)initWithData{
    _completeDatasource = [[NSMutableArray alloc]initWithObjects:@"Complete",@"NMHC Catalyst Monitor", nil];
    _UndfinishedDatasource = [[NSMutableArray alloc]initWithObjects:@"Undfinished",@"Heated Catalyst Monitor", nil];
    _NotsupportDatasource = [[NSMutableArray alloc]initWithObjects:@"Not support",@"Misfire monitor",@"Misfire monitor",@"Misfire monitor",@"Misfire monitor", nil];
    [self initWithUI];
}
- (void)initWithUI{
    TBarView *tbarView = [[TBarView alloc]initWithFrame:CGRectMake(0, MSHeight - 45*KHeightmultiple-64, MSWidth, 45*KHeightmultiple)];
    if (IS_IPHONE_X) {
        tbarView.frame = CGRectMake(0, MSHeight - 45*KHeightmultiple-self.navigationController.navigationBar.frame.size.height -[UIApplication sharedApplication].statusBarFrame.size.height-34,MSWidth , 45*KHeightmultiple);
    }
    tbarView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tbarView.numberBtn = 4;
    tbarView.isSelectNumber = 2;
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return _completeDatasource.count;
        }
            break;
        case 1:
        {
            return _UndfinishedDatasource.count;
        }
            break;
        case 2:
        {
            return _NotsupportDatasource.count;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text= _completeDatasource[indexPath.row];
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor clearColor];
                cell.imageView.image = [UIImage imageNamed:@"green"];
            }
            
        }
            break;
        case 1:
        {
            cell.textLabel.text= _UndfinishedDatasource[indexPath.row];
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor clearColor];
                cell.imageView.image = [UIImage imageNamed:@"red"];
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text= _NotsupportDatasource[indexPath.row];
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor clearColor];
                cell.imageView.image = [UIImage imageNamed:@"black"];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
@end
