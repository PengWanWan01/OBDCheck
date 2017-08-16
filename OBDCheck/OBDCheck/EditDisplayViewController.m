//
//  EditDisplayViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "EditDisplayViewController.h"

@interface EditDisplayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *titleNameArray;

@end

@implementation EditDisplayViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Edit Display" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}

- (void)initWithUI{
//    NSString *ModeStr = [NSString stringWithFormat:@"%ld",(long)[DashboardSetting sharedInstance].dashboardStyle];
    NSLog(@"121,%ld",(long)[DashboardSetting sharedInstance].dashboardStyle);
    
    if ([DashboardSetting sharedInstance].dashboardStyle == DashboardCustomMode) {
      _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Size and Location",@"Dispaly Configuration",@"Style",@"Remove Display",@"Drag and Move",@"Bring to Font", nil];
    }else{
     _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Size and Location",@"Dispaly Configuration",@"Remove Display",@"Drag and Move",@"Bring to Font", nil];
    }
  
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, 220) style:UITableViewStylePlain];
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
    return _titleNameArray.count;
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
    cell.textLabel.text =  _titleNameArray[indexPath.row];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row==0 || indexPath.row ==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            SizeAndLocationViewController *vc = [[SizeAndLocationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            DisplaySetViewController *vc = [[DisplaySetViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
