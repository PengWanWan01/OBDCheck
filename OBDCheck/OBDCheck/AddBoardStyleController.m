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
    [[DashboardSetting sharedInstance] initADDdashboardA:model withTag:0 ];
    [[DashboardSetting sharedInstance] initADDdashboardB:model withTag:0];
    [[DashboardSetting sharedInstance] initADDdashboardC:model withTag:0];
    switch (self.selectIndex) {
        case 100:
        {
            model.dashboardType = 1;
            model.DashboardAorignx = [NSString stringWithFormat:@"%f",self.Currentpage *MSWidth +(arc4random() % (int)(MSWidth/2))];
            model.DashboardAorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
        }
            break;
        case 101:
        {
            model.dashboardType = 2;
            model.DashboardBorignx = [NSString stringWithFormat:@"%f",self.Currentpage*MSWidth+(arc4random() % (int)(MSWidth/2))];
            model.DashboardBorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2) )];
            
        }
            break;
        case 102:
        {
            model.dashboardType = 3;
            model.DashboardCorignx = [NSString stringWithFormat:@"%f",self.Currentpage*MSWidth +(arc4random() % (int)(MSWidth/2))];
            model.DashboardCorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
        }
            break;
        default:
            break;
    }
    [model save];
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
//            model.DashboardAorignx = [NSString stringWithFormat:@"%f",self.Currentpage *MSWidth +(arc4random() % (int)(MSWidth/2))];
//            model.DashboardAorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
//        }
//            break;
//        case 101:
//        {
//            model.dashboardType = 2;
//            model.DashboardBorignx = [NSString stringWithFormat:@"%f",self.Currentpage*MSWidth+(arc4random() % (int)(MSWidth/2))];
//            model.DashboardBorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2) )];
//
//        }
//            break;
//        case 102:
//        {
//            model.dashboardType = 3;
//            model.DashboardCorignx = [NSString stringWithFormat:@"%f",self.Currentpage*MSWidth +(arc4random() % (int)(MSWidth/2))];
//            model.DashboardCorigny = [NSString stringWithFormat:@"%u",(arc4random() % (int)(MSHeight/2))];
//        }
//            break;
//        default:
//            break;
//    }
//    [model save];
}
@end
