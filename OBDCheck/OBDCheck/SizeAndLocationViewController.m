//
//  SizeAndLocationViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SizeAndLocationViewController.h"
#import "UIViewController+NavBar.h"

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
- (void)initWithUI{
    //     diameterPercent = (CGFloat)sender.view.frame.size.width/375;
    
  
    _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Diameter(10-100)",@"Left(0-100)",@"Top(0-100)", nil];
   
    CGFloat diameterPercentStr ;
    CGFloat LeftPercentStr ;
     CGFloat TopPercentStr ;
    // StyleB
    switch ([UserDefaultSet sharedInstance].dashboardStyle ) {
        case DashboardStyleOne:
        {
//           diameterPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"diameterPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
            
//            LeftPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"LeftPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
            
//            TopPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"TopPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
        }
            break;
        case DashboardStyleTwo:{
//            diameterPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBdiameterPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
            
//            LeftPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
            
//            TopPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
        }
            break;
        case DashboardStyleThree:{
//            diameterPercentStr =[[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCdiameterPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
            
//            LeftPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCLeftPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
            
//            TopPercentStr = [[DashboardSetting sharedInstance].defaults floatForKey:[NSString stringWithFormat:@"StyleCTopPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
        }
            break;
        default:
            break;
    }
//    _fieldViewDatasurce = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%.2f",diameterPercentStr],[NSString stringWithFormat:@"%.2f",LeftPercentStr],[NSString stringWithFormat:@"%.2f",TopPercentStr], nil];
    
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
    DLog(@"%lu",(unsigned long)_titleNameArray.count);
    return _titleNameArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
    [cell addSubview:fieldView];
//    cell.accessoryView.
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{


}
- (void)textFieldEditChanged:(UITextField *)textField
{
    DLog(@"textfield text %@",textField.text);
    if ([textField.text integerValue] > 100) {
        textField.text = @"100";
    }
    switch (textField.tag) {
        case 0:
        {
           
            switch ([UserDefaultSet sharedInstance].dashboardStyle) {
                case DashboardStyleOne:
                {
//                      [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]  forKey:[NSString stringWithFormat:@"diameterPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
//                    [UserDefaultSet sharedInstance].
                }
                    break;
                case DashboardStyleTwo :
                {
//                      [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]  forKey:[NSString stringWithFormat:@"StyleBdiameterPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                case DashboardStyleThree:
                {
//                      [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue] forKey:[NSString stringWithFormat:@"StyleCdiameterPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
          
            switch ([[ UserDefaultSet sharedInstance] GetAttribute:@"dashboardStyle"]) {
                case DashboardStyleOne:
                {
//                  [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]   forKey:[NSString stringWithFormat:@"LeftPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                case DashboardStyleTwo :
                {
//                      [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]  forKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                case DashboardStyleThree:
                {
//                      [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]    forKey:[NSString stringWithFormat:@"StyleBLeftPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
          
            switch ([ UserDefaultSet sharedInstance].dashboardStyle) {
                case DashboardStyleOne:
                {
//                    [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]forKey:[NSString stringWithFormat:@"TopPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                case DashboardStyleTwo :
                {
//                    [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]   forKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                case DashboardStyleThree:
                {
//                    [[DashboardSetting sharedInstance].defaults setFloat:[textField.text floatValue]   forKey:[NSString stringWithFormat:@"StyleBTopPercent%ld",(long)[DashboardSetting sharedInstance].Dashboardindex]];
                }
                    break;
                default:
                    break;
            }
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
