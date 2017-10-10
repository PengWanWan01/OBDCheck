//
//  GeneralController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "GeneralController.h"

@interface GeneralController ()
@property (nonatomic,strong) NSMutableArray *detialdataSource;

@end

@implementation GeneralController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initNavBarTitle:@"Communications" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Keep Screen on",@"Currency",@"Alarm Settings",@"Speed alarm",@"Water temperature alarm",@"Speed alarm", nil];
    self.detialdataSource = [[NSMutableArray alloc]initWithObjects:@"120 km/h",@"110 ℃",@"3 h", nil];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger reslut = 0;
    switch (section) {
        case 0:
            {
                reslut = 2;
            }
            break;
        case 1:
        {
            reslut = 4;
        }
            break;
        default:
            break;
    }
    return reslut;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    switch (indexPath.section ) {
        case 0:
            {
                cell.textLabel.text = self.dataSource[indexPath.row];
                if (indexPath.row == 1) {
                    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
                    cell.detailTextLabel.text = @"USD";
                    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            break;
        case 1:
        {
            cell.textLabel.text = self.dataSource[indexPath.row+2];
            if (!(indexPath.row == 0)) {
                cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
                cell.detailTextLabel.text = self.detialdataSource[indexPath.row-1];
            }
        }
            break;
        default:
            break;
    }
    if (indexPath.row == 0) {
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        swit.on = YES;
        cell.accessoryView = swit;
        
    }
    return cell;
}

@end
