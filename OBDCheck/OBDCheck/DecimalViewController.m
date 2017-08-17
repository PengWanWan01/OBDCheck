//
//  DecimalViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/17.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DecimalViewController.h"

@interface DecimalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *DecimalDataSource;
@end

@implementation DecimalViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Number of Decimals" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _DecimalDataSource = [[NSMutableArray alloc]initWithObjects:@"Zero",@"One",@"Two", nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.delegate  =self;
    self.tableView.dataSource = self;
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DecimalDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.text = _DecimalDataSource[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    cell.accessoryView = imageView;
    cell.accessoryView.hidden = YES;
    switch ([DashboardSetting sharedInstance].numberDecimals ) {
        case NumberDecimalZero:{
            if (indexPath.row == 0) {
                cell.accessoryView.hidden = NO;
            }
        }
            break;
        case NumberDecimalOne:{
            if (indexPath.row == 1) {
                cell.accessoryView.hidden = NO;
            }
        }
            break;case NumberDecimalTwo:{
                if (indexPath.row == 2) {
                    cell.accessoryView.hidden = NO;
                }
            }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<_DecimalDataSource.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {
            cell.accessoryView.hidden = NO;
            switch (indexPath.row) {
                case 0:{  //0位小数点
                    [DashboardSetting sharedInstance].numberDecimals = NumberDecimalZero;
                }
                    break;
                case 1:{  //1位小数点
                    [DashboardSetting sharedInstance].numberDecimals = NumberDecimalOne;
                }
                    break;
                case 2:{  //2位小数点
                    [DashboardSetting sharedInstance].numberDecimals = NumberDecimalTwo;
                }
                    break;
                default:
                    break;
            }
            NSLog(@"122,%ld",(long)[DashboardSetting sharedInstance].numberDecimals);
            
        }else{
            cell.accessoryView.hidden = YES;
        }
    }
}


@end
