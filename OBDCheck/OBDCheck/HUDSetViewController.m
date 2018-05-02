//
//  HUDSetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/5/2.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "HUDSetViewController.h"

@interface HUDSetViewController ()
@property (nonatomic,strong)NSMutableArray *headDataSource;
@end

@implementation HUDSetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initWithData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBarTitle:@"HUD 设置" andLeftItemImageName:@"back" andRightItemImageName:@""];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
}

- (void)initWithData{
    self.headDataSource = [[NSMutableArray alloc]initWithObjects:@"Font Color",@"VSS",@"RPM",@"ECT",@"IAT",@"Batterry",@"EOT",nil];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"PID名称字体颜色",@"数值字体颜色",@"单位字体颜色" ,nil];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.dataSource.count;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.backgroundColor =  [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"FFFFFF"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"默认色";
        UISwitch *selectSwitch = [[UISwitch alloc]init];
        selectSwitch.on = [[UserDefaultSet sharedInstance]GetIntegerAttribute:@"HUDColorchange"];
        [selectSwitch addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = selectSwitch;
    }else{
        cell.textLabel.text = self.dataSource[indexPath.row];
        UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
       
            [selectButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        HUDSet *model =   [[OBDataModel sharedDataBase]findTable:@"HUDs" withID:indexPath.section].lastObject;
        
        switch (indexPath.row) {
            case 0:
                {
                    selectButton.backgroundColor = [ColorTools colorWithHexString:model.PIDColor];
                }
                break;
            case 1:
            {
                  selectButton.backgroundColor = [ColorTools colorWithHexString:model.NumberColor];
            }
                break;
            case 2:
            {
                  selectButton.backgroundColor = [ColorTools colorWithHexString:model.UnitColor];
            }
                break;
            default:
                break;
        }
        cell.accessoryView = selectButton;

    }
    return cell;
}
- (void)select:(UISwitch *)btn{
//    if (btn.on == YES) {
        [[UserDefaultSet sharedInstance]SetIntegerAttribute:btn.on Key:@"HUDColorchange"];
//    }else{
//
//    }
}
- (void)button:(UIButton *)btn{
     if (![[UserDefaultSet sharedInstance]GetIntegerAttribute:@"HUDColorchange"]) {
    UITableViewCell * cell = (UITableViewCell *)[btn superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    DLog(@"%ld",path.section);
    DLog(@"%ld",path.row);
   
    HUDColorViewController *vc = [[HUDColorViewController alloc]init];
    vc.indexID = path;
    [self.navigationController pushViewController:vc animated:YES];
     }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 64)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, MSWidth-13, 64)];
    headLabel.text = self.headDataSource[section];
    headLabel.textColor = [ColorTools colorWithHexString:@"FFFFFF"];
    [headView addSubview:headLabel];
    return headView;
    
}
@end
