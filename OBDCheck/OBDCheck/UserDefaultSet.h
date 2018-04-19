//
//  UserDefaultSet.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/19.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,DashboardStyle)
{
    DashboardStyleOne=0,   // 第一种风格
    DashboardStyleTwo=1,    //第二种风格
    DashboardStyleThree=2     //第三种风格
};
typedef NS_ENUM(NSInteger ,DashboardMode)
{
    DashboardClassicMode=0,   //经典模式
    DashboardCustomMode=1    //自定义模式
    
};
typedef NS_ENUM(NSInteger ,NumberDecimals)
{
    NumberDecimalZero=0,   // 0个小数点位数
    NumberDecimalOne=1,    //1个小数点位数
    NumberDecimalTwo=2     //2个小数点位数
};

typedef NS_ENUM(NSInteger ,MultiplierType)
{
    MultiplierType1=0,   // 单位1倍
    MultiplierType1000=1    //单位1000倍
};
@interface UserDefaultSet : NSObject
//单例模式，实例化对象
+(instancetype )sharedInstance;
@property (nonatomic,strong)   NSUserDefaults* defaults;
@property(nonatomic)   DashboardMode dashboardMode;
@property(nonatomic)   DashboardStyle dashboardStyle;
@property (nonatomic) NumberDecimals numberDecimals;
@property (nonatomic) MultiplierType multiplierType;
-(void)SetDefultAttribute;
//设置一个属性
-(BOOL)SetAttribute:(NSInteger )Value Key:(NSString *)key;
//获取一个属性值
-(NSInteger)GetAttribute:(NSString *)Key;
@end
