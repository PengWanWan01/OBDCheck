//
//  AddBoardStyleController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/21.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "AddBoardStyleController.h"

@interface AddBoardStyleController ()<chosseBoardStyleDelegete>
@property(nonatomic,assign)NSInteger selectIndex;
@end

@implementation AddBoardStyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBarTitle:@"Add dashDoard" andLeftItemImageName:@"back" andRightItemName:@""];
    self.delegate = self;
    DLog(@"%ld",self.selectIndex);
}

- (void)chosseBoardStyleBetouched:(NSInteger)index{
    DLog(@"选择%ld",index);
    self.selectIndex = index+100;
   
}
-(void)back{
    CustomDashboard *model = [CustomDashboard new ];
    switch (self.selectIndex) {
        case 100:
        {
            [[DashboardSetting sharedInstance] AddDashBoard:model with:0 with:AddStyleOne];
        }
            break;
        case 101:
        {
            [[DashboardSetting sharedInstance] AddDashBoard:model with:0 with:AddStyleTwo];
        }
            break;
        case 102:
        {
            [[DashboardSetting sharedInstance] AddDashBoard:model with:0 with:AddStyleThree];
        }
            break;
        default:
            break;
    }
    model.Dashboardorignx = [NSString stringWithFormat:@"%f",self.Currentpage *MSWidth +(arc4random() % (int)(MSWidth/2))];
    model.Dashboardorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
    model.DashboardPID = @"Add";
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO CustomDashboard (data) VALUES ('%@')",[model yy_modelToJSONString]];
    [[OBDataModel sharedDataBase]insert:SQLStr];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)rightBarButtonClick{
//    CustomDashboard *model = [CustomDashboard new ];
//    [[DashboardSetting sharedInstance] initADDdashboardA:model withTag:0 ];
//    [[DashboardSetting sharedInstance] initADDdashboardB:model withTag:0];
//    [[DashboardSetting sharedInstance] initADDdashboardC:model withTag:0];
//    switch (self.selectIndex) {
//        case 100:
//        {
//            model.dashboardType = 1;
//            model.Dashboardorignx = [NSString stringWithFormat:@"%f",self.Currentpage *MSWidth +(arc4random() % (int)(MSWidth/2))];
//            model.Dashboardorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
//        }
//            break;
//        case 101:
//        {
//            model.dashboardType = 2;
//            model.Dashboardorignx = [NSString stringWithFormat:@"%f",self.Currentpage*MSWidth+(arc4random() % (int)(MSWidth/2))];
//            model.Dashboardorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2) )];
//
//        }
//            break;
//        case 102:
//        {
//            model.dashboardType = 3;
//            model.Dashboardorignx = [NSString stringWithFormat:@"%f",self.Currentpage*MSWidth +(arc4random() % (int)(MSWidth/2))];
//            model.Dashboardorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
//        }
//            break;
//        default:
//            break;
//    }
//    [model save];
}
@end
