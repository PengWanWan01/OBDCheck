//
//  ChangeBoardStyleController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/21.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "ChangeBoardStyleController.h"

@interface ChangeBoardStyleController ()<chosseBoardStyleDelegete>{
    CustomDashboard *model;
}
@property(nonatomic,assign)NSInteger selectIndex;

@end

@implementation ChangeBoardStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBarTitle:@"Change DashDoard Style" andLeftItemImageName:@"back" andRightItemName:@""];
    self.delegate = self;
    model = [CustomDashboard findByPK:[DashboardSetting sharedInstance].Dashboardindex];
}

- (void)chosseBoardStyleBetouched:(NSInteger)index{
    DLog(@"选择%ld",index);
    self.selectIndex = index+100;
    DLog(@"%ld", model.dashboardType);
    
}
-(void)back{
    switch (self.selectIndex) {
        case 100://dashboardType切换成2或者3,为1的时候不用变化
        {
            if (model.dashboardType ==2 ) {
                
                model.dashboardType = 1;
                model.DashboardAorignx = model.DashboardBorignx;
                model.DashboardAorigny = model.DashboardBorigny;
                model.DashboardAorignwidth = model.DashboardBorignwidth;
                model.DashboardAorignheight = model.DashboardBorignheight;
            }else if (model.dashboardType == 3){
                model.dashboardType = 1;
                model.DashboardAorignx = model.DashboardCorignx;
                model.DashboardAorigny = model.DashboardCorigny;
                model.DashboardAorignwidth = model.DashboardCorignwidth;
                model.DashboardAorignheight = model.DashboardCorignheight;
            }
          
        }
            break;
        case 101: //dashboardType切换成1或者3,为2的时候不用变化
        {
            if (model.dashboardType == 1) {
                DLog(@"切换成功")
                model.dashboardType = 2;
                model.DashboardBorignx = model.DashboardAorignx;
                model.DashboardBorigny = model.DashboardAorigny;
                model.DashboardBorignwidth = model.DashboardAorignwidth;
                model.DashboardBorignheight = model.DashboardAorignwidth;
            }else if (model.dashboardType == 3){
                model.dashboardType = 2;
                model.DashboardBorignx = model.DashboardCorignx;
                model.DashboardBorigny = model.DashboardCorigny;
                model.DashboardBorignwidth = model.DashboardCorignwidth;
                model.DashboardBorignheight = model.DashboardCorignheight;
            }
           
        }
            break;
        case 102: //dashboardType切换成1或者2,为3的时候不用变化
        {
            if (model.dashboardType == 1) {
                model.dashboardType = 3;
                model.DashboardCorignx = model.DashboardAorignx;
                model.DashboardCorigny = model.DashboardAorigny;
                model.DashboardCorignwidth = model.DashboardAorignwidth;
                model.DashboardCorignheight = model.DashboardAorignwidth;
            }else if (model.dashboardType == 2){
                model.dashboardType = 3;
                model.DashboardCorignx = model.DashboardBorignx;
                model.DashboardCorigny = model.DashboardBorigny;
                model.DashboardCorignwidth = model.DashboardBorignwidth;
                model.DashboardCorignheight = model.DashboardBorignheight;
            }
        }
            break;
        default:
            break;
    }
    [model update];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
