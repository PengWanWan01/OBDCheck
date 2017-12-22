//
//  CommunicationController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "CommunicationController.h"

@interface CommunicationController ()
@property(nonatomic,strong)NSMutableArray *sectionDataSource;

@end

@implementation CommunicationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Communications" andLeftItemImageName:@"back" andRightItemImageName:@""];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionDataSource = [[NSMutableArray alloc]initWithObjects:@"WI-FI SETTINGS",@"OBD-II PROTOCOL",@"GENERAL", nil];
    self.dataSource = [[NSMutableArray alloc]initWithObjects:@"Device",@"Protocol",@"Protocol",@"Connection",@"Connect Silently", nil];
     [self.tableView registerNib:[UINib nibWithNibName:@"selectTableViewCell" bundle:nil] forCellReuseIdentifier:@"selectTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
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
#pragma mark 设置横竖屏布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIDeviceOrientation interfaceOrientation= [UIDevice currentDevice].orientation;
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation ==UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        //        UIInterfaceOrientation
        DLog(@"竖屏");
        [self setVerticalFrame];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation ==UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        DLog(@"横屏");
        [self setHorizontalFrame];
        
        
    }
}
#pragma mark 竖屏
- (void)setVerticalFrame{
    
    
}
#pragma mark 横屏
- (void)setHorizontalFrame{
    
    
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result = 0;
    switch (section) {
        case 0:
            {
                result = 1;
            }
            break;
        case 1:
        {
           result = 2;
        }
            break;
        case 2:
        {
            result = 2;
        }
            break;
        default:
            break;
    }
    return result;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, MSWidth, 24.f)];
    label.text = self.sectionDataSource[section];
    label.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    label.font = [UIFont boldSystemFontOfSize:14.f];
    [headView addSubview:label];
    return headView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *resultCell;
    selectTableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:@"selectTableViewCell"];
    StyleThreeTableViewCell *StylethreeCell = [tableView dequeueReusableCellWithIdentifier:@"StyleThreeTableViewCell"];
  
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        resultCell.layoutMargins = UIEdgeInsetsZero;
    }
  

    if (indexPath.row == 0) {
        selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
        resultCell = selectCell;
        switch (indexPath.section) {
            case 0:
                {
                    selectCell.PIDLabel.text = @"OBDCHECK WI-FI";
                }
                break;
            case 1:
            {
                selectCell.PIDLabel.text = @"Automatic";
            }
                break;
            case 2:
            {
                selectCell.PIDLabel.text = @"Manual";
            }
                break;
            default:
                break;
        }
      
    }else{
        StylethreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        resultCell = StylethreeCell;

    }
    return resultCell;
}

@end
