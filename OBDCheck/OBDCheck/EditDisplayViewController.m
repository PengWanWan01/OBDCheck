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
    _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Size and Location",@"Dispaly Configuration",@"Style",@"Remove Display",@"Drag and Move",@"Bring to Font", nil];
    [self initWithUI];
}

- (void)initWithUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, MSHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
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
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    if (indexPath.row==0 || indexPath.row ==1 || indexPath.row ==2) {
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
        case 2:
        {
            StyleViewController *vc = [[StyleViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
//            StyleViewController *vc = [[StyleViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            [DashboardSetting sharedInstance].isDashboardMove = YES;
//            DashboardController *VC = [[DashboardController alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];

            [self back];
        }
            break;
        case 5:
        {
            [DashboardSetting sharedInstance].isDashboardFont = YES;
            [self back];

//            DashboardController *VC = [[DashboardController alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
