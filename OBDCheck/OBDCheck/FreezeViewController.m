//
//  FreezeViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/30.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "FreezeViewController.h"

@interface FreezeViewController ()

@property(nonatomic,strong)NSMutableArray *FreezeDataDTCsource;
@property(nonatomic,strong)NSMutableArray *FreezeDatasource;

@end

@implementation FreezeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Diagnostics1" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithData];
}
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight-TopHigh-64-49);
}
#pragma mark 竖屏
- (void)setVerticalFrame{

}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
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
- (void)initWithData{
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"FREEZE FRAME DTC",@"FREEZE FRAME", nil];
    self.FreezeDataDTCsource = [[NSMutableArray alloc]initWithObjects:@"P0103",nil];
    //MIL on,# Trouble codes4,Misfire: Available=False
    self.FreezeDatasource = [[NSMutableArray alloc]initWithObjects:@"MIL on,# Trouble codes4,Misfire: Available=False",nil];
    [self initWithUI];
}
- (void)initWithUI{
   
}

- (void)back{
 
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return _FreezeDataDTCsource.count;
        }
            break;
        case 1:
        {
            return _FreezeDatasource.count;
        }
            break;
        default:
            break;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    label.text = self.dataSource[section];
    label.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    label.font = [UIFont boldSystemFontOfSize:14.f];
    [headView addSubview:label];
    return headView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text= _FreezeDataDTCsource[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"troubleCode_highLight"];
        }
            break;
        case 1:
        {
            cell.textLabel.text= _FreezeDatasource[indexPath.row];
            cell.textLabel.numberOfLines = 0;
        }
            break;
       
        default:
            break;
    }
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
