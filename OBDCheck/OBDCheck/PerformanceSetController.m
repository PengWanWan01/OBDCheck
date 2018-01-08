
//
//  PerformanceSetController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/14.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformanceSetController.h"
#import "UIViewController+NavBar.h"

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
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
- (void)initWithData{
    self.dataSource =  [[NSMutableArray alloc]initWithObjects:@"Test Items",@"Start speed",@"End speed",nil];
    
}
- (void)initWithUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHigh, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    self.tableView.backgroundColor = [ColorTools colorWithHexString:@"212329"];
    [self.view addSubview:self.tableView];
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
           NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"startSpeed"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ km/h",str];
        }else{
            NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"endSpeed"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ km/h",str];
        }
    }
    return cell;
}
- (void)textFieldEditChanged:(UITextField *)textField
{
   
    DLog(@"得到内容%@ %ld",textField.text, (long)textField.tag);
    switch (textField.tag) {
        case 1:
            {
            [[PerformanceSetting sharedInstance].defaults setObject:textField.text forKey:@"startSpeed"];
            }
            break;
        case 2:
           {
             [[PerformanceSetting sharedInstance].defaults setObject:textField.text forKey:@"endSpeed"];
           }
            break;
        default:
            break;
    }
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
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.tag = indexPath.section;
            [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
            }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"startSpeed"];
            UITableViewCell * cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ km/h",str];
            }]];
         
        [self presentViewController:alertController animated:true completion:nil];
        }
            break;
        case 2:
        {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"End speed" message:@"Please enter the End speed!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.tag = indexPath.section;
            [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
            }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击确定按钮
            NSString *str = [[PerformanceSetting sharedInstance].defaults objectForKey:@"endSpeed"];
            UITableViewCell * cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ km/h",str];
   
            }]];
        [self presentViewController:alertController animated:true completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
