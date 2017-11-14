
//
//  PerformanceSetController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/14.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformanceSetController.h"

@interface PerformanceSetController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation PerformanceSetController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Performance" andLeftItemImageName:@"back" andRightItemImageName:@" "];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initWithData];
    [self initWithUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initWithData{
    self.dataSource =  [[NSMutableArray alloc]initWithObjects:@"Test Items",@"Start speed",@"End the mileage",nil];
    
}
- (void)initWithUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHigh, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    return headView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    cell.textLabel.text = self.dataSource[indexPath.section];
    cell.detailTextLabel.textColor =  [ColorTools colorWithHexString:@"#C8C6C6"];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (indexPath.section == 1) {
            cell.detailTextLabel.text = @"0  km/h";
        }else{
            cell.detailTextLabel.text =  @"300 m";
        }
    }
    return cell;
}
- (void)textFieldEditChanged:(UITextField *)textField
{

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
                TestItemViewController *vc = [[TestItemViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
        {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Start speed" message:@"Please enter the start speed!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入BUTTON名称";
            }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            //present出AlertView
        [self presentViewController:alertController animated:true completion:nil];
        }
            break;
        case 2:
        {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"End the mileage" message:@"Please enter the End the mileage!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入BUTTON名称";
            }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击确定按钮
            }]];
        [self presentViewController:alertController animated:true completion:nil];
        }
            break;
        default:
            break;
    }
}
@end
