//
//  DashboardSetting.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger ,AddDashboardStyle)
{
    AddStyleNone=0,
    AddStyleOne,   // 添加第一种风格
    AddStyleTwo,    //添加第二种风格
    AddStyleThree    //添加第三种风格
};
typedef NS_ENUM(NSInteger ,ChangeDashboardStyle)
{
    ChangeDashboardStyleNone=0,
    ChangeDashboardStyleOne,   // 改变为第一种风格
    ChangeDashboardStyleTwo,    //改变为第二种风格
    ChangeDashboardStyleThree    //改变为第三种风格
};


typedef NS_ENUM(NSInteger ,ProtocolType)
{
    CanProtocol,   // Can 拓展协议
    KWProtocol    //KW协议
};
@class CustomDashboard;

@interface DashboardSetting : NSObject
@property (nonatomic) AddDashboardStyle addStyle;
@property (nonatomic) ChangeDashboardStyle ChangeStyle;

@property (nonatomic,assign) NSInteger Dashboardindex;   //被选中可以移动的仪表盘
@property (nonatomic,assign) NSInteger RemoveDashboardNumber;   //移除的仪表盘
@property (nonatomic,assign) BOOL isDashboardFont;          //是否跳到最前面
@property (nonatomic,assign) BOOL isDashboardMove;          //是否可以移动
@property (nonatomic,assign) BOOL isDashboardRemove;          //是否可以删除
@property (nonatomic,assign) BOOL isAddDashboard;   //是否添加仪表盘
@property (nonatomic,assign) BOOL ischangeDashboard;   //是否改变仪表盘风格

@property (nonatomic,strong) NSMutableArray *DashboardViewFrame;    //是否可以移动
@property (nonatomic,assign) NSInteger blueState;    //蓝牙连接状态
@property (nonatomic,assign) NSInteger protocolType;    //蓝牙连接协议

@property (nonatomic,assign)   BOOL DashBoardFristLoad;
@property (nonatomic,assign) NSInteger CurrentPage;   //当前仪表盘页数

@property (nonatomic,copy) NSArray *PIDDataSource; //存放PID的内容
//单例模式，实例化对象
+(instancetype )sharedInstance;
- (void)initWithdashboardA;
- (void)initWithdashboardB;
- (void)initWithdashboardC;
- (void)initwithCustomDashboard;

- (void)initADDdashboardA:(CustomDashboard *)model withTag:(NSInteger )i;
- (void)initADDdashboardB:(CustomDashboard *)model withTag:(NSInteger )i;
- (void)initADDdashboardC:(CustomDashboard *)model withTag:(NSInteger )i;


- (void)CustomDashboardType:(AddDashboardStyle)type  withTag:(NSInteger)i;


@end
