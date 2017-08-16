//
//  DashboardSetting.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,DashboardMode)
{
    DashboardClassicMode=0,   //经典模式
    DashboardCustomMode=1,    //自定义模式
    
};

typedef NS_ENUM(NSInteger ,DashboardStyle)
{
    DashboardStyleOne=0,   // 第一种风格
    DashboardStyleTwo=1,    //第二种风格
    DashboardStyleThree=2     //第三种风格
};

@interface DashboardSetting : NSObject
@property(nonatomic)   DashboardMode dashboardMode;
@property(nonatomic)   DashboardStyle dashboardStyle;

//单例模式，实例化对象
+(instancetype )sharedInstance;

@end
