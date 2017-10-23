//
//  BELInfo.h
//  CarApp－ByMe
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 com.Autophix.T100. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BELInfo : NSObject

//储存搜索到的蓝牙设备
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) NSNumber *rssi;

@end
