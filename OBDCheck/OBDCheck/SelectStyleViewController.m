//
//  SelectStyleViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "SelectStyleViewController.h"
#import "UIViewController+NavBar.h"

@interface SelectStyleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *MyTableView;
}
@property (nonatomic,strong) NSMutableArray *styleDataArray;
@property (nonatomic,assign)  NSInteger indexID;
@end

@implementation SelectStyleViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards Style" andLeftItemImageName:@"back" andRightItemName:@"done"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [DashboardSetting sharedInstance].addStyle = AddStyleNone;
    [DashboardSetting sharedInstance].ChangeStyle = ChangeDashboardStyleNone;
    self.indexID  = [DashboardSetting sharedInstance].Dashboardindex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        //翻转为竖屏时
        DLog(@"竖屏");
        [self setVerticalFrame];
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    MyTableView.frame = CGRectMake(0, 34, SCREEN_MIN, _styleDataArray.count*44) ;
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    MyTableView.frame = CGRectMake(0, 34, SCREEN_MAX, _styleDataArray.count*44) ;
    
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
    _styleDataArray = [[NSMutableArray alloc]initWithObjects:@"One",@"Two",@"Three",nil];
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, MSWidth, _styleDataArray.count*44) style:UITableViewStylePlain];
    MyTableView.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    MyTableView.separatorInset = UIEdgeInsetsZero;
    MyTableView.scrollEnabled = NO;
    MyTableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    MyTableView.delegate = self;
    MyTableView.dataSource = self;
    [MyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:MyTableView];
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
    if ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] == DashboardClassicMode) {
        switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardStyle"]) {
            case DashboardStyleOne:{
                if (indexPath.row == 0) {
                    cell.accessoryView.hidden = NO;
                }
            }
                break;
            case DashboardStyleTwo:{
                if (indexPath.row == 1) {
                    cell.accessoryView.hidden = NO;
                }
            }
                break;
            case DashboardStyleThree:{
                if (indexPath.row == 2) {
                    cell.accessoryView.hidden = NO;
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
    switch ([[UserDefaultSet sharedInstance] GetIntegerAttribute:@"dashboardMode"] ) {
        case DashboardCustomMode:  //在自定义
        {
            for (NSInteger i = 0; i<_styleDataArray.count; i++) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (i == indexPath.row) {
                    cell.accessoryView.hidden = NO;
                    switch (indexPath.row) {
                        case 0:{     //第一种仪表盘
                            [DashboardSetting sharedInstance].addStyle = AddStyleOne;
                            [DashboardSetting sharedInstance].ChangeStyle = ChangeDashboardStyleOne;
                        }
                            break;
                        case 1:{     //第二种仪表盘
                            [DashboardSetting sharedInstance].addStyle = AddStyleTwo;
                            [DashboardSetting sharedInstance].ChangeStyle = ChangeDashboardStyleTwo;
                        }
                            break;
                        case 2:{         //第三种仪表盘
                            [DashboardSetting sharedInstance].addStyle = AddStyleThree;
                            [DashboardSetting sharedInstance].ChangeStyle = ChangeDashboardStyleThree;
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
            break;
        case DashboardClassicMode://在经典模式下就是切换仪表盘风格
        {
            for (NSInteger i = 0; i<_styleDataArray.count; i++) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (i == indexPath.row) {
                    cell.accessoryView.hidden = NO;
                    switch (indexPath.row) {
                        case 0:{     //第一种仪表盘
                            [UserDefaultSet sharedInstance].dashboardStyle = DashboardStyleOne;
                            [[UserDefaultSet sharedInstance]SetIntegerAttribute:[UserDefaultSet sharedInstance].dashboardStyle Key:@"dashboardStyle"];
                            
                        }
                            break;
                        case 1:{     //第二种仪表盘
                            [UserDefaultSet sharedInstance].dashboardStyle = DashboardStyleTwo;
                            [[UserDefaultSet sharedInstance]SetIntegerAttribute:[UserDefaultSet sharedInstance].dashboardStyle Key:@"dashboardStyle"];
                        }
                            break;
                        case 2:{         //第三种仪表盘
                            [UserDefaultSet sharedInstance].dashboardStyle = DashboardStyleThree;
                            [[UserDefaultSet sharedInstance]SetIntegerAttribute:[UserDefaultSet sharedInstance].dashboardStyle Key:@"dashboardStyle"];
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
            break;
        default:
            break;
    }
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
//    if ([DashboardSetting sharedInstance].ischangeDashboard == YES) {
//
//
//        NSArray *list = [CustomDashboard findAll];
//        for (CustomDashboard *dash in list ) {
//            if (dash.pk == self.indexID) {
//
//
//                switch (dash.dashboardType) {
//                    case 1:
//                    {
//                        switch ([DashboardSetting sharedInstance].ChangeStyle) {
//                            case ChangeDashboardStyleTwo:
//                            {
//                                dash.dashboardType = 2;
//                                [self updateCustomType:2 OrignX:[dash.DashboardAorignx floatValue] OrignY:[dash.Dashboardorigny floatValue] Width:[dash.Dashboardorignwidth floatValue] Height:[dash.Dashboardorignwidth floatValue] ID:self.indexID];
//
//                            }
//                                break;
//                            case ChangeDashboardStyleThree:
//                            {
//                                dash.dashboardType = 3;
//                                [self updateCustomType:3 OrignX:[dash.DashboardAorignx floatValue] OrignY:[dash.Dashboardorigny floatValue] Width:[dash.Dashboardorignwidth floatValue] Height:[dash.Dashboardorignheight floatValue] ID:self.indexID];
//                            }
//                                break;
//                            default:
//                                break;
//                        }
//
//                    }
//                        break;
//                    case 2:
//                    {
//                        switch ([DashboardSetting sharedInstance].ChangeStyle) {
//                            case ChangeDashboardStyleOne:
//                            {
//                                dash.dashboardType = 1;
//                                [self updateCustomType:1 OrignX:[dash.Dashboardorignx floatValue] OrignY:[dash.Dashboardorigny floatValue] Width:[dash.Dashboardorignwidth floatValue] Height:[dash.Dashboardorignwidth  floatValue]+20 ID:self.indexID];
//                            }
//                                break;
//                            case ChangeDashboardStyleThree:
//                            {
//                                dash.dashboardType = 3;
//                                [self updateCustomType:3 OrignX:[dash.Dashboardorignx floatValue] OrignY:[dash.Dashboardorigny floatValue] Width:[dash.Dashboardorignwidth floatValue] Height:[dash.Dashboardorignwidth  floatValue] ID:self.indexID];
//                            }
//                                break;
//                            default:
//                                break;
//                        }
//
//                    }
//                        break;
//                    case 3:
//                    {
//                        switch ([DashboardSetting sharedInstance].ChangeStyle) {
//                            case ChangeDashboardStyleOne:
//                            {
//                                dash.dashboardType = 1;
//                                [self updateCustomType:1 OrignX:[dash.Dashboardorignx floatValue] OrignY:[dash.Dashboardorigny floatValue] Width:[dash.Dashboardorignwidth floatValue] Height:[dash.Dashboardorignwidth  floatValue]+20 ID:self.indexID];
//                            }
//                                break;
//                            case ChangeDashboardStyleTwo:
//                            {
//                                dash.dashboardType = 2;
//                                [self updateCustomType:2 OrignX:[dash.Dashboardorignx floatValue] OrignY:[dash.Dashboardorigny floatValue] Width:[dash.Dashboardorignwidth floatValue] Height:[dash.Dashboardorignwidth  floatValue] ID:self.indexID];
//                            }
//                                break;
//                            default:
//                                break;
//                        }
//
//                    }
//                        break;
//                    default:
//                        break;
//                }
//
//            }
//        }
//        [DashboardSetting sharedInstance].ischangeDashboard = NO;
//    }
    
}
- (void)rightBarButtonClick{
    
}
- (void)updateCustomType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(CGFloat)id{
    
    NSArray *array = [CustomDashboard findAll];
    for(CustomDashboard *dash in array){
        //        if(dash.dashboardA.orignx == @(23) ){
        
        switch (Customtype) {
            case 1:
            {
                
                dash.Dashboardorignx = [NSString stringWithFormat:@"%f",orignx];
                dash.Dashboardorigny = [NSString stringWithFormat:@"%f",origny];
                dash.Dashboardorignwidth = [NSString stringWithFormat:@"%f",width];
                dash.Dashboardorignheight = [NSString stringWithFormat:@"%f",height];
                
            }
                break;
            case 2:
            {
                dash.Dashboardorignx = [NSString stringWithFormat:@"%f",orignx];
                dash.Dashboardorigny = [NSString stringWithFormat:@"%f",origny];
                dash.Dashboardorignwidth = [NSString stringWithFormat:@"%f",width];
                dash.Dashboardorignheight = [NSString stringWithFormat:@"%f",height];
            }
                break;
            case 3:
            {
                dash.Dashboardorignx = [NSString stringWithFormat:@"%f",orignx];
                dash.Dashboardorigny = [NSString stringWithFormat:@"%f",origny];
                dash.Dashboardorignwidth = [NSString stringWithFormat:@"%f",width];
                dash.Dashboardorignheight = [NSString stringWithFormat:@"%f",height];
                
            }
                break;
            default:
                break;
        }
        [dash update];
        //        }
    }
    
    
    
}
@end

