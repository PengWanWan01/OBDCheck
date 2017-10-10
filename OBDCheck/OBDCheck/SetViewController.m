//
//  SetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *datasource;
@end

@implementation SetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Settings" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    [self initWithUI];
}
- (void)initWithData{

    self.datasource = [[NSMutableArray alloc
                       ]initWithObjects:@"Preferences",@"Information",@"Firmware Updates",@"Connection Help",@"License Agreement",@"Privacy Policy", nil];
    
}
- (void)initWithUI{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight) style:UITableViewStyleGrouped];
    tableview.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    tableview.delegate = self;
    tableview.dataSource =  self;
  [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44.f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    switch (section) {
        case 0:
            {
                
              result =  1;
            }
            break;
        case 1:
        {
            
            result =  _datasource.count-1;
        }
            break;
        default:
            break;
    }
    return  result;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
     cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    switch (indexPath.section) {
        case 0:
            {
                cell.textLabel.text = _datasource[indexPath.row];
            }
            break;
        case 1:
        {
            cell.textLabel.text = _datasource[indexPath.row+1];
        }
            break;
        default:
            break;
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}


@end
