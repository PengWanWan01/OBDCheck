//
//  editDashboardsView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/9.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "editDashboardsView.h"
@interface editDashboardsView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *titileArray;
@end
@implementation editDashboardsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ColorTools colorWithHexString:@"#3B3F49"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 8)];
        view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 32, 0, 16, 8)];
        imageView.image = [UIImage imageNamed:@"triangle"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:view];
        [view addSubview:imageView];
        _titileArray = [[NSMutableArray alloc]initWithObjects:@"Edit Dashboards",@"Dashboards Mode",@"Dashboards Style",@"Add Display",@"Add Dashboard",@"Remove Dashboard",@"Load Default Dashboards",@"Toggle HUD Mode",@"Calibrate Device Sensors", nil];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, self.bounds.size.width, self.bounds.size.height - 8)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.scrollEnabled = NO;
        tableView.separatorColor = [ColorTools colorWithHexString:@"#212329"];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
        [self addSubview:tableView];
    }
    return self;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titileArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60.f;
    }else{
        return 44.f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
       
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =  _titileArray[indexPath.row];
     cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#FE9002"]];
        cell.textLabel.font = [UIFont systemFontOfSize:18.f];
    }else if (indexPath.row == 2 ||  indexPath.row == 1){
        //设置Mode 与Style的内容显示；
        [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 120, 0, 80, 44)];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [selectBtn setTitleColor:[ColorTools colorWithHexString:@"#FE9002"] forState:UIControlStateNormal];
        [selectBtn setTitle:@"One" forState:UIControlStateNormal];
        
        if (indexPath.row == 1) {
            switch ([DashboardSetting sharedInstance].dashboardMode) {
                case DashboardClassicMode:{
                    [selectBtn setTitle:@"Classic" forState:UIControlStateNormal];
                }
                    break;
                case DashboardCustomMode:{
                    [selectBtn setTitle:@"Custom" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
            
        }
        if (indexPath.row == 2) {
            switch ([DashboardSetting sharedInstance].dashboardStyle) {
                case DashboardStyleOne:{
                    [selectBtn setTitle:@"One" forState:UIControlStateNormal];
                }
                    break;
                case DashboardStyleTwo:{
                    [selectBtn setTitle:@"Two" forState:UIControlStateNormal];
                }
                    break;
                case DashboardStyleThree:{
                    [selectBtn setTitle:@"Three" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
        }
        //选择Mode 与Style的设置
        selectBtn.tag = indexPath.row;
        [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:selectBtn];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
    [cell.textLabel setTextColor:[ColorTools colorWithHexString:@"#C8C6C6"]];
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hide];
    if (indexPath.row == 4||indexPath.row == 5 || indexPath.row == 6) {
            if ([self.delegate respondsToSelector:@selector(AlertBetouched:)]) {
                [self.delegate AlertBetouched:indexPath.row];
            }
    }
   

}
- (void)show{
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    //        UIView *topView = [win.subviews firstObject];
    //        [topView addSubview:self];
    [win addSubview:self];
    
    [win bringSubviewToFront:self];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [self layoutIfNeeded];
    }];
    
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)selectBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectStyleBtnBetouched:)]) {
        [self.delegate selectStyleBtnBetouched:btn.tag];
    }
}
@end
