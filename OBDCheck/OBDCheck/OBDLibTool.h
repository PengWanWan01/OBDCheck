//
//  OBDLibTool.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/9.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "OBDCHECKLIBOC.h"

//@protocol BlueToothControllerDelegate <NSObject>
//
//@end
@interface OBDLibTool : OBDCHECKLIBOC
//单例模式，实例化对象
+(instancetype )sharedInstance;
@property (nonatomic,assign) BOOL LoadSuccess;
@property (nonatomic,assign) BOOL EnterSuccess;
@property (nonatomic,copy) NSData *input; //输入数据
@property (nonatomic,copy) NSData *output; //输出数据
@property (nonatomic,copy) NSData *sendData;////最终蓝牙发送结果
@property (nonatomic,copy) NSData *reslutData; //上一帧的内容
@property (nonatomic,copy)   NSData *currentData; //当前帧的内容
@property (nonatomic,copy)   NSData *totalData; //等待6S的内容
@property (nonatomic,copy)   NSData *resolveData; //等待6S的内容
@property (nonatomic,copy)   NSData *backData; //蓝牙返回内容

//蓝牙管理类
@property (nonatomic,strong) BlueToothController *blueTooth ;

- (void)InitTool;//进入设备
- (void)OBDIIReadDTC:(NSString *)str; //去读故障码
@end
