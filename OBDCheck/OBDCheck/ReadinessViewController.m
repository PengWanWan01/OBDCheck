//
//  ReadinessViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ReadinessViewController.h"

@interface ReadinessViewController ()
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
}
-(void)back{
    
    
    ViewController *vc = [[ViewController alloc
                           ]init];
    [self.navigationController pushViewController:vc animated:YES];
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
