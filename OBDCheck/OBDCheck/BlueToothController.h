//
//  BlueToothController.h
//  CarApp－ByMe
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 com.Autophix.T100. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BELInfo.h"


//蓝牙状态的枚举类型
typedef NS_ENUM(NSUInteger, BlueToothState)
{
    BlueToothStateDisScan = 0,          //停滞不搜索状态
    BlueToothStateScan,                 //搜索状态
    BlueToothStateConnect,              //已连接状态
};

//蓝牙委托
@protocol BlueToothControllerDelegate <NSObject>

///收到外围设备传输过来的数据时的接口
-(void)BlueToothEventWithReadData:(CBPeripheral*)peripheral Data:(NSData*)data;

@optional
//蓝牙状态改变时的接口
-(void)BlueToothState:(BlueToothState)state;
/*
//蓝牙状态改变时的接口
-(void)BlueToothState:(BlueToothState)state;
//读取RSSI值时的接口
-(void)GetRSSI:(CGFloat)RSSI;
*/
@end
//typedef void (^DeviceNameBlock)(BELInfo *)info;
typedef void(^DeviceNameBlock)(NSMutableArray *infoArray);

@interface BlueToothController : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

-(instancetype)init;

//中心设备管理对象
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic,strong) CBPeripheral* ConnectPeripheral;

//蓝牙设备列表
@property (nonatomic, strong) NSMutableArray *arrayBLE;

@property (nonatomic , strong) id<BlueToothControllerDelegate> delegate;
@property(nonatomic, copy) DeviceNameBlock deviceNameBlock;



//单例
+(BlueToothController*)Instance;

//断开连接
-(void)DisConnectBlueTooth;

//发送数据
-(void)SendData:(NSData*)data;
//主动开启搜索
-(void)Scan;

//是否链接了设备
-(BOOL)isConnectPeripheral;


@end
