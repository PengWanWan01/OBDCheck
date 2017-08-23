//
//  SizeAndLocationViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SizeAndLocationViewController.h"

@interface SizeAndLocationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *titleNameArray;
@property (nonatomic,strong) NSMutableArray *fieldViewDatasurce;

@end

@implementation SizeAndLocationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Size and Location" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
- (void)initWithUI{
    //     diameterPercent = (CGFloat)sender.view.frame.size.width/375;
    
  
    _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Diameter(10-100)",@"Left(0-100)",@"Top(0-100)", nil];
   
    NSString *diameterPercentStr = [NSString stringWithFormat:@"%@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"diameterPercent%ld",[DashboardSetting sharedInstance].Dashboardindex]]];
    
    NSString *LeftPercentStr = [NSString stringWithFormat:@"%@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"LeftPercent%ld",[DashboardSetting sharedInstance].Dashboardindex]]];
    
     NSString *TopPercentStr = [NSString stringWithFormat:@"%@",[[DashboardSetting sharedInstance].defaults objectForKey:[NSString stringWithFormat:@"TopPercent%ld",[DashboardSetting sharedInstance].Dashboardindex]]];
    _fieldViewDatasurce = [[NSMutableArray alloc]initWithObjects:diameterPercentStr,LeftPercentStr,TopPercentStr, nil];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, 44*_titleNameArray.count) style:UITableViewStylePlain];
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
    NSLog(@"%lu",(unsigned long)_titleNameArray.count);
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
    UITextField *fieldView = [[UITextField alloc]initWithFrame:CGRectMake(MSWidth - 205, 0,200, 44)];
    fieldView.textAlignment = NSTextAlignmentRight;
    fieldView.textColor  = [ColorTools colorWithHexString:@"#C8C6C6"];
    fieldView.tag = indexPath.row;
    fieldView.text = _fieldViewDatasurce[indexPath.row];
    fieldView.delegate = self;
    fieldView.keyboardType = UIKeyboardTypeNumberPad;
    [fieldView addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
//    switch (indexPath.row) {
//        case 0:
//        {
//            [DashboardSetting sharedInstance].diameter = fieldView.text;
//            NSLog(@"%@", fieldView.text);
//            
//        }
//            break;
//        case 1:
//        {
//            [DashboardSetting sharedInstance].Left = fieldView.text;
//        }
//            break;
//        case 2:
//        {
//            [DashboardSetting sharedInstance].Top = fieldView.text;
//        }
//            break;
//        default:
//            break;
//    }
//    fieldView.delegate = self;
    [cell addSubview:fieldView];
//    cell.accessoryView.
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{


}
- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"textfield text %@",textField.text);
    if ([textField.text integerValue] > 100) {
        textField.text = @"100";
    }
    switch (textField.tag) {
        case 0:
        {
             [[DashboardSetting sharedInstance].defaults setObject:textField.text  forKey:[NSString stringWithFormat:@"diameterPercent%ld",[DashboardSetting sharedInstance].Dashboardindex]];
        }
            break;
        case 1:
        {
            [[DashboardSetting sharedInstance].defaults setObject:textField.text   forKey:[NSString stringWithFormat:@"LeftPercent%ld",[DashboardSetting sharedInstance].Dashboardindex]];
        }
            break;
        case 2:
        {
            [[DashboardSetting sharedInstance].defaults setObject:textField.text  forKey:[NSString stringWithFormat:@"TopPercent%ld",[DashboardSetting sharedInstance].Dashboardindex]];
        }
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
            
        default:
            break;
    }
}

@end
