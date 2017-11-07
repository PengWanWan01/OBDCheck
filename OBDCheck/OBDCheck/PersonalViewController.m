//
//  PersonalViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *Mytableview;
    
}
@property (nonatomic,strong) NSMutableArray *normalImage;
@property (nonatomic,strong) NSMutableArray *selectImage;
@property (nonatomic,strong) NSMutableArray *sectionDatasource;
@property (nonatomic,strong) NSMutableArray *texttitleDatasource;
@property (nonatomic,strong) NSMutableArray *titleBtnData;

@end

@implementation PersonalViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Personal" andLeftItemImageName:@" " andRightItemName:@"Menu"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
      [self initWithData];
    [self initWithUI];
 
    
}
- (void)initWithData{
    self.normalImage = [[NSMutableArray alloc]initWithObjects:@"OBD_normal",@"Vehicle_normal", nil];
    self.selectImage = [[NSMutableArray alloc]initWithObjects:@"OBD_highlight",@"Vehicle_highlight", nil];
    self.sectionDatasource = [[NSMutableArray alloc]initWithObjects:@"NAME",@"VEHICLE IDENTIFICATION NUMBER",@"YEAR",@"MAKE",@"MODEL",@"OPTION",@"TYPE",@"FUEL TYPE",@"ENGINE SIZE(LITRES)",@"VOLUMETRIC EFFICIENCY(%)",@"BRAKE SPECIFIC FUEL CONSUMPTION(LB/HP·HR)",@"FUEL CALCULATION METHOD",@"FUEL TANK CAPACITY (GAL)",@"FUEL COST PER UNIT ($)",@"VEHICLE SPEED SCALE FACTOR", nil];
    self.texttitleDatasource = [[NSMutableArray alloc]initWithObjects:@"NAME",@"1A1J5444R7252367",@"1996",@"AC",@"Cobra",@"Option",@"Select",@"Select",@"2",@"65",@"0.45",@"Select",@"14.0",@"4.0",@"1", nil];
    self.titleBtnData = [[NSMutableArray alloc]initWithObjects:@"OBD Features",@"Vehicle Information", nil];
}
- (void)initWithUI{
    Mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight-64-10) style:UITableViewStyleGrouped];
    if (IS_IPHONE_X) {
        Mytableview.frame  = CGRectMake(0, 0, MSWidth, MSHeight-132);
    }
    Mytableview.backgroundColor = [UIColor clearColor];
    Mytableview.dataSource = self;
    Mytableview.delegate = self;
    Mytableview.separatorInset = UIEdgeInsetsZero;
    Mytableview.separatorColor = [ColorTools colorWithHexString:@"#212329"];
    [self.view addSubview:Mytableview];
    [Mytableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    for (NSInteger i = 0; i< 2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(MSWidth/2), MSHeight - 49-TopHigh,MSWidth/2 , 49)];
        if (IS_IPHONE_X) {
            btn.frame = CGRectMake(i*(MSWidth/2), MSHeight - 49-TopHigh-34,MSWidth/2 , 49);
        }
        [btn setBackgroundImage: [UIImage imageNamed:_normalImage[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        if (i==1) {
            [btn setBackgroundImage: [UIImage imageNamed:_selectImage[i]] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(Selectbtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(42*KFontmultiple, 0, btn.frame.size.width-42*KFontmultiple, 49)];
        titleLabel.font = [UIFont ToAdapFont:16.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setText:_titleBtnData[i]];
        [titleLabel setTextColor:[ColorTools colorWithHexString:@"#1E2026"]];
        [btn addSubview:titleLabel];
        [self.view addSubview:btn];
    }
}
- (void)Selectbtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            ViewController *vc = [[ViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        case 1:
        {
            PersonalViewController *vc = [[PersonalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
            break;
        default:
            break;
    }
}
- (void)rightBarButtonClick{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:@"MENU" preferredStyle:UIAlertControllerStyleActionSheet];
    // 响应方法-取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
    }];
    // 响应方法-相册
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Delete Vehicle" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了删除按钮");
        [self deleteVehicle];
    }];
    // 响应方法-拍照
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Select Vehicle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了选择按钮");
         [self selectVehicle];
    }];
    // 添加响应方式
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:takeAction];
    [actionSheetController addAction:photoAction];
    // 显示
    [self presentViewController:actionSheetController animated:YES completion:nil];
}
- (void)deleteVehicle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete the active vehicle?" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self SureDeleteVehicle];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
- (void)selectVehicle{
    SeletVehicleViewController *vc = [[SeletVehicleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)SureDeleteVehicle{
    NSLog(@"确认删除");
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionDatasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
        return 54.f;
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 54)];
        View.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 24, MSWidth, 24)];
        label.text = self.sectionDatasource[section];
        label.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
        [View addSubview:label];
        return View;
  
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
    cell.textLabel.text = self.texttitleDatasource[indexPath.section];
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.selectionStyle =  UITableViewCellEditingStyleNone;
    if ((indexPath.section == 2) || (indexPath.section == 3) || (indexPath.section == 4) || (indexPath.section == 5) ||(indexPath.section == 6) || (indexPath.section == 7)|| (indexPath.section == 11))  {
        cell.detailTextLabel.text = @"select";
        cell.detailTextLabel.textColor = [ColorTools colorWithHexString:@"FE9002"];
        if ((indexPath.section == 6) ) {
            cell.detailTextLabel.text = @"Sedan";
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }else if ( indexPath.section == 7){
            cell.detailTextLabel.text = @"Gasoline/pertrol";
             cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section == 11){
            cell.detailTextLabel.text = @"Mass air flow rate";
             cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section == 8 || indexPath.section == 9 ||indexPath.section == 10 ||indexPath.section == 14 ) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Personal_sigh"]];
        cell.accessoryView = imageView;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 2:
            {
                YearViewController *VC = [[YearViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
        case 3:
        {
            MakerViewController *VC = [[MakerViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:
        {
            ModerViewController *VC = [[ModerViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 6:
        {
            TyperViewController *VC = [[TyperViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 7:
        {
            FuleTypeViewController *VC = [[FuleTypeViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 11:
        {
            FuelCaculationViewController *VC = [[FuelCaculationViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
@end
