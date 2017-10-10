//
//  CommunicationController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "CommunicationController.h"

@interface CommunicationController ()
@property(nonatomic,strong)NSMutableArray *sectionDataSource;

@end

@implementation CommunicationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Communications" andLeftItemImageName:@"back" andRightItemImageName:@""];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionDataSource = [[NSMutableArray alloc]initWithObjects:@"WI-FI SETTINGS",@"OBD-II PROTOCOL",@"GENERAL", nil];
    
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Device",@"Protocol",@"Protocol",@"Connection",@"Connect Silently", nil];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    switch (section) {
        case 0:
            {
                result = 1;
            }
            break;
        case 1:
        {
           result = 2;
        }
            break;
        case 2:
        {
            result = 2;
        }
            break;
        default:
            break;
    }
    return result;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    label.text = self.sectionDataSource[section];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0) {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
        switch (indexPath.section) {
            case 0:
                {
                    cell.detailTextLabel.text = @"OBDCHECK WI-FI";
                }
                break;
            case 1:
            {
                cell.detailTextLabel.text = @"Automatic";
            }
                break;
            case 2:
            {
                cell.detailTextLabel.text = @"Manual";
            }
                break;
            default:
                break;
        }
      
    }else{
        
    }
    return cell;
}

@end
