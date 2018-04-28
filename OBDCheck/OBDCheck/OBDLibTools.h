//
//  OBDLibTools.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/9.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "BlueToothController.h"

//@protocol BlueToothControllerDelegate <NSObject>
//
//@end
extern Byte inputData[CmdDataSetSize];
extern Byte outputData[CmdDataSetSize];
extern Byte StreamDataPID[CmdDataSetSize];

@interface OBDLibTools : OBDCHECKLIBOC

//单例模式，实例化对象
+(instancetype )sharedInstance;
@property (nonatomic,assign) BOOL LoadSuccess;
@property (nonatomic,assign) BOOL EnterSuccess;
//@property (nonatomic,assign) Byte inputData[CmdDataSetSize]; //输入数据
//@property (nonatomic,assign) Byte outputData[CmdDataSetSize]; //输出数据

@property (nonatomic,copy)   NSData *backData; //蓝牙返回内容
@property (nonatomic,strong)NSMutableArray *troubleCodeArray;
@property (nonatomic,strong)NSMutableArray *explainCodeArray;
@property (nonatomic,assign)   NSInteger MessageVal; //
@property (nonatomic,assign)   NSInteger PIDNum; //

//蓝牙管理类
@property (nonatomic,strong)BlueToothController *blueTooth ;
- (void)InitTool;//进入设备
- (void)OBDIIReadDTC; //去读故障码
- (void)OBDIIDataStream; //去读数据流
- (void)SendMessageAndWaitLibThread:(int )mS;

@end
