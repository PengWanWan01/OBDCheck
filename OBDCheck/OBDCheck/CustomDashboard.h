//
//  CustomDashboard.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/7.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "Tool_FMDBModel.h"
@class DashboardA;
@class DashboardB;
@class DashboardC;

@interface CustomDashboard : Tool_FMDBModel
@property (nonatomic,strong) DashboardA * dashboardA ;
@property (nonatomic,strong) DashboardB * dashboardB ;
@property (nonatomic,strong) DashboardC * dashboardC ;
@property (nonatomic,assign) NSInteger  dashboardType ;

@end
