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
@property (nonatomic,assign)  NSInteger indexID;
@end

@implementation SelectStyleViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Dashboards Style" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [DashboardSetting sharedInstance].addStyle = AddStyleNone;
    [DashboardSetting sharedInstance].ChangeStyle = ChangeDashboardStyleNone;
    self.indexID  = [DashboardSetting sharedInstance].Dashboardindex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUI];
}

- (void)initWithUI{
    _styleDataArray = [[NSMutableArray alloc]initWithObjects:@"One",@"Two",@"Three",nil];
    
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
    if ([DashboardSetting sharedInstance].dashboardMode == DashboardClassicMode) {
    switch ([DashboardSetting sharedInstance].dashboardStyle ) {
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
    switch ([DashboardSetting sharedInstance].dashboardMode) {
        case DashboardCustomMode:
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
        case DashboardClassicMode:
        {
            for (NSInteger i = 0; i<_styleDataArray.count; i++) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (i == indexPath.row) {
                    cell.accessoryView.hidden = NO;
                    switch (indexPath.row) {
                        case 0:{     //第一种仪表盘
                            [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleOne;
                          
                        }
                            break;
                        case 1:{     //第二种仪表盘
                            [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleTwo;
                            
                        }
                            break;
                        case 2:{         //第三种仪表盘
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
            break;
        default:
            break;
    }
   
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];

    if ([DashboardSetting sharedInstance].ischangeDashboard == YES) {
     
    NSString *findsql = [NSString stringWithFormat:@"WHERE  ID = %@",[NSNumber numberWithInteger: [DashboardSetting sharedInstance].Dashboardindex]];
    NSArray *AL =  [CustomDashboard findByCriteria:findsql];
    for (CustomDashboard *dash in AL ) {
        if (dash.pk == self.indexID) {
            
      
        switch (dash.dashboardType) {
            case 1:
            {
                switch ([DashboardSetting sharedInstance].ChangeStyle) {
                    case ChangeDashboardStyleTwo:
                    {
                        dash.dashboardType = 2;
                        [self updateCustomType:2 OrignX:[dash.dashboardA.orignx floatValue] OrignY:[dash.dashboardA.origny floatValue] Width:[dash.dashboardA.orignwidth floatValue] Height:[dash.dashboardA.orignwidth floatValue] ID:self.indexID];
                        
                    }
                        break;
                    case ChangeDashboardStyleThree:
                    {
                        dash.dashboardType = 3;
                        [self updateCustomType:3 OrignX:[dash.dashboardA.orignx floatValue] OrignY:[dash.dashboardA.origny floatValue] Width:[dash.dashboardA.orignwidth floatValue] Height:[dash.dashboardA.orignheight floatValue] ID:self.indexID];
                    }
                        break;
                    default:
                        break;
                }
            
            }
                break;
            case 2:
            {
                switch ([DashboardSetting sharedInstance].ChangeStyle) {
                    case ChangeDashboardStyleOne:
                    {
                        dash.dashboardType = 1;
                        [self updateCustomType:1 OrignX:[dash.dashboardB.orignx floatValue] OrignY:[dash.dashboardB.origny floatValue] Width:[dash.dashboardB.orignwidth floatValue] Height:[dash.dashboardB.orignwidth  floatValue]+20 ID:self.indexID];
                    }
                        break;
                    case ChangeDashboardStyleThree:
                    {
                        dash.dashboardType = 3;
                        [self updateCustomType:3 OrignX:[dash.dashboardB.orignx floatValue] OrignY:[dash.dashboardB.origny floatValue] Width:[dash.dashboardB.orignwidth floatValue] Height:[dash.dashboardB.orignwidth  floatValue] ID:self.indexID];
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case 3:
            {
                switch ([DashboardSetting sharedInstance].ChangeStyle) {
                    case ChangeDashboardStyleOne:
                    {
                        dash.dashboardType = 1;
                        [self updateCustomType:1 OrignX:[dash.dashboardC.orignx floatValue] OrignY:[dash.dashboardC.origny floatValue] Width:[dash.dashboardC.orignwidth floatValue] Height:[dash.dashboardC.orignwidth  floatValue]+20 ID:self.indexID];
                    }
                        break;
                    case ChangeDashboardStyleTwo:
                    {
                        dash.dashboardType = 2;
                        [self updateCustomType:2 OrignX:[dash.dashboardC.orignx floatValue] OrignY:[dash.dashboardC.origny floatValue] Width:[dash.dashboardC.orignwidth floatValue] Height:[dash.dashboardC.orignwidth  floatValue] ID:self.indexID];
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
            [dash update];

        }
    }
        [DashboardSetting sharedInstance].ischangeDashboard = NO;
    }
    
}
- (void)updateCustomType:(NSInteger )Customtype  OrignX:(CGFloat)orignx OrignY:(CGFloat)origny Width:(CGFloat)width Height:(CGFloat)height ID:(CGFloat)id{

    NSArray *array = [CustomDashboard findAll];
    for(CustomDashboard *dash in array){
        if(dash.pk == id ){
           
    switch (Customtype) {
        case 1:
        {
            
             dash.dashboardA.orignx = [NSNumber numberWithFloat:orignx];
             dash.dashboardA.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardA.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardA.orignheight = [NSNumber numberWithFloat:height];
           
        }
            break;
        case 2:
        {
            dash.dashboardB.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardB.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardB.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardB.orignheight = [NSNumber numberWithFloat:height];
        }
            break;
        case 3:
        {
            dash.dashboardC.orignx = [NSNumber numberWithFloat:orignx];
            dash.dashboardC.origny = [NSNumber numberWithFloat:origny];
            dash.dashboardC.orignwidth = [NSNumber numberWithFloat:width];
            dash.dashboardC.orignheight = [NSNumber numberWithFloat:height];
            
        }
            break;
        default:
            break;
    }
            [dash update];
        }
    }
   
    
    
}
@end
