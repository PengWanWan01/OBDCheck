//
//  SelectStyleViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SelectStyleViewController.h"

@interface SelectStyleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *styleDataArray;
@end

@implementation SelectStyleViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards Style" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUI];
}
- (void)initWithUI{
    _styleDataArray = [[NSMutableArray alloc]initWithObjects:@"One",@"Two",@"1212",nil];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, _styleDataArray.count*44) style:UITableViewStylePlain];
    tableView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.scrollEnabled = NO;
    tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:tableView];
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _styleDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  _styleDataArray[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yes"]];
    cell.accessoryView = imageView;
    cell.accessoryView.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i<_styleDataArray.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
       if (i == indexPath.row) {
            cell.accessoryView.hidden = NO;
           switch (indexPath.row) {
               case 0:{
                  [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleOne;
               }
                   break;
               case 1:{
                     [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleTwo;
               }
                   break;
               case 2:{
                     [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleThree;
               }
                   break;
               default:
                   break;
           }
          
        }else{
            cell.accessoryView.hidden = YES;
            
        }
    }
}


@end
