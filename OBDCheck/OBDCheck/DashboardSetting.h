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
    DashboardCustomMode    //自定义模式
    
};

typedef NS_ENUM(NSInteger ,DashboardStyle)
{
    DashboardStyleOne=0,   // 第一种风格
    DashboardStyleTwo,    //第二种风格
    DashboardStyleThree=2     //第三种风格
};

typedef NS_ENUM(NSInteger ,NumberDecimals)
{
    NumberDecimalZero=0,   // 0个小数点位数
    NumberDecimalOne,    //1个小数点位数
    NumberDecimalTwo     //2个小数点位数
};

typedef NS_ENUM(NSInteger ,MultiplierType)
{
    MultiplierType1=0,   // 单位1倍
    MultiplierType1000    //单位1000倍
};
typedef NS_ENUM(NSInteger ,HUDModeType)
{
    HUDModeTypeToHUD,   // 变成HUD类型
    HUDModeTypeToNormal    //变成正常类型
};

@interface DashboardSetting : NSObject
@property(nonatomic)   DashboardMode dashboardMode;
@property(nonatomic)   DashboardStyle dashboardStyle;
@property (nonatomic) NumberDecimals numberDecimals;
@property (nonatomic) MultiplierType multiplierType;
@property (nonatomic) HUDModeType hudModeType;
@property (nonatomic,assign)  NSInteger KPageNumer; //仪表盘的原始页数
@property (nonatomic,assign) NSInteger Dashboardindex;   //被选中可以移动的仪表盘
@property (nonatomic,assign) NSInteger AddDashboardNumber;   //添加的仪表盘个数
@property (nonatomic,assign) NSInteger RemoveDashboardNumber;   //移除的仪表盘
@property (nonatomic,assign) BOOL isDashboardFont;          //是否跳到最前面
@property (nonatomic,assign) BOOL isDashboardMove;          //是否可以移动
@property (nonatomic,assign) BOOL isDashboardRemove;          //是否可以删除

@property (nonatomic,strong) NSMutableArray *DashboardViewFrame;    //是否可以移动


@property (nonatomic,strong)   NSUserDefaults* defaults;

//单例模式，实例化对象
+(instancetype )sharedInstance;
//设置一个属性
-(BOOL)SetAttribute:(CGFloat)Value Key:(NSString *)key;
//获取一个属性值
-(CGFloat)GetAttribute:(NSString *)Key;
@end
