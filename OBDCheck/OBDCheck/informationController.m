//
//  informationController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "informationController.h"

@interface informationController ()
@property (nonatomic,strong) NSMutableArray *detialdataSource;

@end

@implementation informationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Information" andLeftItemImageName:@"back" andRightItemImageName:@""];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Preferences",@"Company",@"Version",@"Copyright",@"Architecture",@"Developed by", nil];
    self.detialdataSource = [[NSMutableArray alloc]initWithObjects:@"OBDCHECK",@"OBD Solutions",@"0.0.1",@"Copyright © Autophix 2017",@"64-bit",@"Autophix",nil];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
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
    cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"918E8E"];
    cell.detailTextLabel.text = self.detialdataSource[indexPath.row];
    return cell;
}


@end
