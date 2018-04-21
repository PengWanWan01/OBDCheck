//
//  DisplaySetViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DisplaySetViewController.h"
#import "UIViewController+NavBar.h"

@interface DisplaySetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *MyTableView;
    CustomDashboard *model;
    
    
}
@property (nonatomic,strong) NSMutableArray *titleNameArray;
@property (nonatomic,strong) NSMutableArray *detailArray;


@end

@implementation DisplaySetViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyTableView reloadData];
    [self initNavBarTitle:@"Display Configuration" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
    [self initWithUI];
    
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (isLandscape) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
    }else{
        DLog(@"竖屏");
        [self setVerticalFrame];
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    MyTableView.frame = CGRectMake(0, 34, SCREEN_MIN, SCREEN_MAX-TopHigh) ;
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    MyTableView.frame = CGRectMake(0, 34, SCREEN_MAX, SCREEN_MIN-TopHigh) ;
    
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
    
    
    switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"]) {
        case DashboardClassicMode:
        {
            _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"PID", nil];
        }
            break;
        case DashboardCustomMode:
        {
            _titleNameArray = [[NSMutableArray alloc]initWithObjects:@"Instant fuel economy",@"Min",@"Max",@"PID",@"Multiplier", nil];
        }
            break;
        default:
            break;
    }
    
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, MSHeight-TopHigh) style:UITableViewStylePlain];
    MyTableView.backgroundColor = [UIColor clearColor];
    MyTableView.separatorInset = UIEdgeInsetsZero;
    MyTableView.scrollEnabled = NO;
    MyTableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    [MyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:MyTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)viewTapped
{
    [self.view endEditing:YES];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"]) {
        case DashboardClassicMode:
        {
            return 1;
        }
            break;
        case DashboardCustomMode:{
            return 4;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch ([[UserDefaultSet sharedInstance]GetIntegerAttribute:@"dashboardMode"]) {
        case DashboardClassicMode:
        {
            return 1;
        }
            break;
        case DashboardCustomMode:{
            if (section == 1) {
                return 2;
            }else{
                return 1;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 34.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    footView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section==1) {
        return 34;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    HeadView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, MSWidth - 20, 34)];
    [label setTintColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
    label.textColor =[ColorTools colorWithHexString:@"#C8C6C6"];
    [HeadView addSubview:label];
    if (section == 0) {
        label.text = @"TITLE(CAN BE BLANK)";
        return HeadView;
    }else if (section == 1){
        label.text = @"RANGE";
        return HeadView;
    }else{
        return nil;
    }
    
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
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0)) {
        cell.textLabel.text =  _titleNameArray[indexPath.section];
    }else{
        cell.textLabel.text =  _titleNameArray[indexPath.section+1 ];
    }
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    if (indexPath.section ==1 ) {
        UITextField *selectfield = [[UITextField alloc]initWithFrame:CGRectMake(MSWidth - 50, 0, 50, 44)];
        //        selectBtn.backgroundColor = [UIColor redColor];
        selectfield.textAlignment  = NSTextAlignmentCenter;
        selectfield.tag = indexPath.row;
            switch (indexPath.row) {
                case 0:
                {
                    switch (model.dashboardType) {
                        case 1:
                        {
                            selectfield.text = model.DashboardAminNumber ;
                            
                        }
                            break;
                        case 2:
                        {
                            selectfield.text = model.DashboardBminNumber ;
                        }
                            break;
                        case 3:
                        {
                            selectfield.text = model.DashboardCminNumber ;
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1:
                {
                    switch (model.dashboardType) {
                        case 1:
                        {
                            selectfield.text = model.DashboardAmaxNumber ;
                            
                        }
                            break;
                        case 2:
                        {
                            selectfield.text = model.DashboardBmaxNumber ;
                            
                        }
                            break;
                        case 3:
                        {
                            selectfield.text = model.DashboardCmaxNumber ;
                            
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
        selectfield.delegate = self;
        [selectfield setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
        selectfield.keyboardType = UIKeyboardTypeNumberPad;
        [selectfield addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.accessoryView = selectfield;
        
    }
    if (indexPath.section==2 || indexPath.section ==3 ) {
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSWidth - 240, 0, 200, 44)];
        //        selectBtn.backgroundColor = [UIColor redColor];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#FE9002"] forState:UIControlStateNormal];
        [selectBtn setTitle:_detailArray[indexPath.section - 2] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = indexPath.section;
        [cell addSubview:selectBtn];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.section) {
            case 3:{
                switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"multiplierType"]) {
                    case MultiplierType1:
                    {
                        [selectBtn setTitle:@"X1" forState:UIControlStateNormal];
                    }
                        break;
                    case MultiplierType1000:
                    {
                        [selectBtn setTitle:@"X1000" forState:UIControlStateNormal];
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
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            PIDSelectViewController *vc = [[PIDSelectViewController alloc ]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            MultiplierViewController *vc = [[MultiplierViewController alloc ]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)textFieldEditChanged:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 0:
        {
            switch (model.dashboardType) {
                    
                case 1:
                {
                    
                    if ([textField.text integerValue] > [model.DashboardAmaxNumber integerValue]) {
                        [self showWarn];
                        textField.text = [NSString stringWithFormat:@"%.f", [model.DashboardAmaxNumber floatValue] -1];
                    }
                    model.DashboardAminNumber = textField.text;
                }
                    break;
                case 2:
                {
                    
                    model.DashboardBminNumber = textField.text;
                    if ([textField.text integerValue] > [model.DashboardBmaxNumber integerValue]) {
                        [self showWarn];
                        textField.text = [NSString stringWithFormat:@"%.f", [model.DashboardBmaxNumber floatValue] -1];
                    }
                    model.DashboardBminNumber = textField.text;
                }
                    break;
                case 3:
                {
                    
                    if ([textField.text integerValue] > [model.DashboardCmaxNumber integerValue]) {
                        [self showWarn];
                        textField.text = [NSString stringWithFormat:@"%.f", [model.DashboardCmaxNumber floatValue] -1];
                    }
                    model.DashboardCminNumber = textField.text;
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            
            switch (model.dashboardType) {
                    
                case 1:
                {
                    
                    if ([model.DashboardAminNumber integerValue] > [textField.text integerValue]) {
                        [self showWarn];
                        textField.text = [NSString stringWithFormat:@"%.f", [model.DashboardAminNumber floatValue] +1];
                    }
                    model.DashboardAmaxNumber = textField.text;
                }
                    break;
                case 2:
                {
                    
                    if ([model.DashboardBminNumber integerValue] > [textField.text integerValue]) {
                        [self showWarn];
                        textField.text = [NSString stringWithFormat:@"%.f", [model.DashboardBminNumber floatValue] +1];
                    }
                    model.DashboardBmaxNumber = textField.text;
                }
                    break;
                case 3:
                {
                    
                    if ([model.DashboardCminNumber integerValue] > [textField.text integerValue]) {
                        [self showWarn];
                        textField.text = [NSString stringWithFormat:@"%.f", [model.DashboardCminNumber floatValue] +1];
                    }
                    model.DashboardCmaxNumber = textField.text;
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
- (void)showWarn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warn" message:@"The minimum value you enter can not be greater than the maximum value  " preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)selectBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 2:
        {
            PIDSelectViewController *vc = [[PIDSelectViewController alloc ]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:
        {
            MultiplierViewController *vc = [[MultiplierViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        default:
            break;
    }
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [model update];
    
    //    if([model.bg_id integerValue] == [DashboardSetting sharedInstance].Dashboardindex ){
    //        CustomDashboard *dash = [CustomDashboard new];
    //        dash.dashboardC.maxNumber =model.dashboardC.maxNumber;
    //        dash.dashboardB.maxNumber =model.dashboardB.maxNumber;
    //        dash.dashboardA.maxNumber =model.dashboardA.maxNumber;
    //        dash.dashboardA.minNumber =model.dashboardA.minNumber;
    //        dash.dashboardB.minNumber =model.dashboardB.minNumber;
    //        dash.dashboardC.minNumber =model.dashboardC.minNumber;
    ////        [dash bg_updateWhere:<#(NSArray * _Nullable)#>];
    //
    //    }
    
    
}
- (void)rightBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

