//
//  HUDColorViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/22.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "HUDColorViewController.h"
#import "UIViewController+NavBar.h"

@interface HUDColorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *Colordatasource;
@property (nonatomic,strong)NSMutableArray *ColorStrdatasource;

@end

@implementation HUDColorViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self initNavBarTitle:@"HUD" andLeftItemImageName:@"back" andRightItemImageName:@""];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ColorTableViewCell"];
    
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
    self.Colordatasource  = [[NSMutableArray alloc]initWithObjects:@"Green",@"Light blue",@"White",@"Yellow",@"Blue", nil];
    self.ColorStrdatasource = [[NSMutableArray alloc]initWithObjects:@"44FF00",@"14F1FF",@"FFFFFF",@"FFFF00",@"42B0FF", nil];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            {
                return self.Colordatasource.count;
            }
            break;
        case 1:
        {
            return 1;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 54.f;
    }else{
    return 34.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 34)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    if (section == 0) {
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 54)];
        View.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 24, MSWidth, 24)];
    label.text = @"Select color";
    label.textColor = [ColorTools colorWithHexString:@"C8C6C6"];
    [View addSubview:label];
        return View;
    }else{
    return headView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorTableViewCell"];
    switch (indexPath.section) {
        case 0:
            {
                [cell.imageColor setBackgroundColor:[ColorTools colorWithHexString:self.ColorStrdatasource[indexPath.row]]];
                cell.titleColor.text = self.Colordatasource[indexPath.row];
                cell.SelcetColor.hidden = YES;
            }
            break;
        case 1:{
            cell.imageColor.hidden = YES;
            cell.titleColor.hidden = YES;
            cell.SelcetColor.hidden = YES;
            cell.textLabel.text = @"HUD";
            }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    cell.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
   
                for (NSInteger i = 0; i<self.ColorStrdatasource.count; i++) {
    
                ColorTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                if (i == indexPath.row){
                  
                    switch (indexPath.section) {
                        case 0:
                            {
                                cell.SelcetColor.hidden = NO;
                                [UserDefaultSet sharedInstance].HUDColourStr = self.ColorStrdatasource[indexPath.row];
                                [[UserDefaultSet sharedInstance]SetStringAttribute:[UserDefaultSet sharedInstance].HUDColourStr Key:@"HUDColourStr"];
                            }
                            break;
                        case 1:
                        {
                            
                            
                        }
                            break;
                        default:
                            break;
                    }
       
                }else{
                    cell.SelcetColor.hidden = YES;
                }
                }
}

@end
