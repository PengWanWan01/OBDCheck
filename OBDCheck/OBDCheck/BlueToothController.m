//
//  BlueToothController.m
//  CarApp－ByMe
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 com.Autophix.T100. All rights reserved.
//
#define BLUENAME @"Autophix"
//OBD-ABC V100
//FFE0 FFE1
//49535343-FE7D-4AE5-8FA9-9FAFD205E455
//49535343-6DAA-4D02-ABF6-19569ACA69FE
#define BLUE_SERVER @"FFF0"
#define BLUE_CHARACTERISTIC_READ @"FFF1"
#define BLUE_CHARACTERISTIC_WRITE @"FFF2"
//改变
#import "BlueToothController.h"

@interface BlueToothController ()

{
    //储存特征值
    CBCharacteristic* SendCharacteristic;//读特征
    CBCharacteristic* ReadCharacteristic;//写特征
    
    //储存服务值
    CBService* MyServer;
    
    //发送数据处理数据的信号灯
    NSCondition* condition;    
    //发送数据处理的锁
    NSLock* lock;
    //是否连接到蓝牙的计时器
    NSTimer* timer;
    NSString *sendDataStr;
    NSMutableString *dataStr;
    
}

@end

@implementation BlueToothController

-(BOOL)isConnectPeripheral
{
    if (SendCharacteristic != nil && ReadCharacteristic != nil ) {
        return YES;
    }
    return NO;
}

static BlueToothController* instance;

+(BlueToothController*)Instance
{
    if (instance == nil) {
        instance = [[BlueToothController alloc] init];
    }
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        //实例化
        self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.arrayBLE = [[NSMutableArray alloc] init];
        self.centralMgr.delegate = self;
        
        //初始化锁和信号灯
        condition = [[NSCondition alloc] init];
        lock = [[NSLock alloc] init];
       
     
        
        
    }
        return self;
}

//查询到状态时调用的函数
#pragma mark step1开始搜索蓝牙
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            
            [self.centralMgr scanForPeripheralsWithServices:nil options:dic];
            //开启计时器50秒内没有连接到蓝牙设备，停止搜索
            timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(BLStopScan) userInfo:nil repeats:NO];
            if (self.delegate) {
                @try {
                    [self.delegate BlueToothState:BlueToothStateScan];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
                @finally {
                    
                }
            }
            
            NSLog(@"开始搜索蓝牙～～～");
            
            break;
            
        default:
            //否则记录为no
            NSLog(@"设备存在问题，无法搜索蓝牙~");
            break;
    }
}


//读取RSSI值
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
//    if (self.delegate) {
//        if ([[self.delegate class] instancesRespondToSelector:@selector(GetRSSI:)]) {
////            [self.delegate GetRSSI:[RSSI doubleValue]];
//        }
//        
//    }
}
#pragma mark step2处理搜索到的设备
//处理搜索到的设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    
    BELInfo *discoveredBLEInfo = [[BELInfo alloc] init];
    discoveredBLEInfo.discoveredPeripheral = peripheral;
    discoveredBLEInfo.rssi = RSSI;
    
    //如果已经连接过了设备，就不再保存了
    if (self.arrayBLE.count > 0) {
        return;
    }
    
    // 储存连接搜索到的蓝牙设备
    if (![self saveBLE:discoveredBLEInfo]) {
        NSLog(@"蓝牙设备保存连接失败！～～");
    };
}
//保存蓝牙设备
#pragma mark step3打印搜索到的设备
#pragma mark step4搜索为查找的蓝牙时候，并进行连接
-(BOOL)saveBLE:(BELInfo*)info
{
    NSLog(@"发现设备%@:%@",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
    
    //如果名字为Autophix，则连接并且保存返回yes
    if ([info.discoveredPeripheral.name isEqualToString:BLUENAME]) {
        //连接蓝牙
        if (![self ConnectBlueTooth:info.discoveredPeripheral]) {
            NSLog(@"蓝牙连接失败！");
            return NO;
        }
        else
        {
            [self.arrayBLE addObject:info];
            NSLog(@"蓝牙连接成功！连接上设备名为：%@，UUID为%@的设备",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
        }
    }
    
    
    return YES;
    
}

#pragma mark连接蓝牙函数
-(BOOL)ConnectBlueTooth:(CBPeripheral*)pheral
{
    //连接蓝牙设备
    [self.centralMgr connectPeripheral:pheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //记录连接的蓝牙,并且设置该外围设备协议
    self.ConnectPeripheral = pheral;
    [pheral setDelegate:self];
    return YES;
}

#pragma mark连接蓝牙的时候触发的协议函数
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //关闭停止搜索的计时器
    [timer invalidate];
    //获取T100的UUID
    CBUUID* MyServerUUID = [CBUUID UUIDWithString:BLUE_SERVER];
    //打包成数组
    NSArray* uuida = [NSArray arrayWithObject:MyServerUUID];
    //搜索该UUID服务
    [peripheral discoverServices:uuida];
    NSLog(@"开始搜索蓝牙的服务！！");

}

#pragma mark没连上的时候的响应函数
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"蓝牙断开了链接！！开始重新搜索!!");
    //断开连接协议
    if (self.delegate) {
        @try {
            [self.delegate BlueToothState:BlueToothStateScan];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        
    }

    //清除之前保存的所有信息
    [self.arrayBLE removeAllObjects];
    SendCharacteristic = nil;
    ReadCharacteristic = nil;
    
 
    
    //重新搜索
    [self Scan];
    //开启计时器50秒内没有连接到蓝牙设备，停止搜索
    timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(BLStopScan) userInfo:nil repeats:NO];
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
   
    NSLog(@"通知%@",characteristic.value );
}
#pragma mark重新搜索
-(void)Scan
{
//    Toast* toast = [Toast makeText:NSLocalizedString(@"开始搜索附近的设备", @"")];
//    [toast showWithType:LongTime];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    //重新搜索
    [self.centralMgr scanForPeripheralsWithServices:nil options:dic];
    if (self.delegate) {
        @try {
            [self.delegate BlueToothState:BlueToothStateScan];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    }
    //开启计时器50秒内没有连接到蓝牙设备，停止搜索
    timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(BLStopScan) userInfo:nil repeats:NO];
}
#pragma mark 停止搜索
-(void)BLStopScan
{
    [self.centralMgr stopScan];
    //显示吐司
//    Toast* toast = [Toast makeText:NSLocalizedString(@"蓝牙搜索已停止，如需搜索请点击开始连接按钮", @"")];
//    [toast showWithType:LongTime];
    //改变状态
    if (self.delegate) {
        @try {
            [self.delegate BlueToothState:BlueToothStateConnect];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    }
}

#pragma mark 搜索服务的时候触发的协议函数
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        for (CBService* server in peripheral.services) {
            //搜索该服务的特征值
            [peripheral discoverCharacteristics:nil forService:server];
            NSLog(@"搜索到了一个服务：%@",server.UUID.UUIDString);
        }
    }
    else
    {
        NSLog(@"搜索服务失败，失败提示：%@",error);
    }
}
#pragma mark 扫描完每一个特征值之后调用该函数
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        //扫描每一个特征
        for (CBCharacteristic* character in service.characteristics) {
            
            NSLog(@"搜索到一个特征：%@",character.UUID.UUIDString);
            
            //如果是写的特征，写入发送特征对象中
            if ([character.UUID.UUIDString isEqualToString:BLUE_CHARACTERISTIC_WRITE]) {
                SendCharacteristic = character;
            }
            //如果是读特征，写入读特征对象中
            if ([character.UUID.UUIDString isEqualToString:BLUE_CHARACTERISTIC_READ]) {
              
                //绑定监听
                    [self.ConnectPeripheral setNotifyValue:YES forCharacteristic:character];
            
            }
        }

        if (self.delegate) {
            @try {
                [self.delegate BlueToothState:BlueToothStateConnect];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            @finally {
                
            }
            
        }
    }
    else
    {
        NSLog(@"搜索特征失败，失败提示：%@",error);
    }
  
}
#pragma mark校验和
- (Byte)checkSumFun:(char[] )data withSum:(NSInteger)startIndex{
    char sumChar = 0x00;
    for (NSInteger i = startIndex; i < strlen(data)/2; i++) {
        sumChar = sumChar + data[i];
    }
    return sumChar;
    
}
#pragma mark 通过特征值发送数据
-(void)SendData:(NSData*)data
{


    NSLog(@"发出数据：%@",data);
    
    sendDataStr = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    
    if (SendCharacteristic) {
         
        [self.ConnectPeripheral writeValue:data forCharacteristic:SendCharacteristic type:CBCharacteristicWriteWithResponse];
        // CBCharacteristicWriteWithResponse
    }
    dataStr = [[NSMutableString alloc]init];
    
}


#pragma mark发送数据线程
//////////////////////////////////////////////////////
-(void)SenddataByOtherWay:(NSData*)data
{
    [lock lock];
    NSLog(@"2发出数据：%@",data);
    //需要响应的发送数据
    if (SendCharacteristic) {
        [self.ConnectPeripheral writeValue:data forCharacteristic:SendCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    //发送完之后，等待处理完成,如果五十秒后，无反馈，继续
    [condition waitUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:50]];
    [lock unlock];
//    [condition wait];
    
}
//////////////////////////////////////////////////////


//-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//
//}
-(NSString*)nsDataToHexString:(NSData*)data withSpaces:(BOOL)spaces
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@"\n"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@" "];
        }
    }
    return hex;
    //return [hex autorelease];
}

#pragma mark监听读特征的协议函数

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    NSData* data = characteristic.value;
    NSLog(@"收到了一条源数据：%@",data);
   
    NSString *resultStr = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    
    
    if ([sendDataStr isEqualToString:resultStr]) {
       
    }else{
        [dataStr appendString:resultStr];
        NSData* xmlData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        //调用协议的函数
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(BlueToothEventWithReadData:Data:)]) {
                [self.delegate BlueToothEventWithReadData:peripheral Data:xmlData];
            }
            
        }
    }
    
 
    
}

#pragma mark断开连接
-(void)DisConnectBlueTooth
{
    self.ConnectPeripheral.delegate = nil;
    [self.centralMgr cancelPeripheralConnection:self.ConnectPeripheral];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
//        [self updateLog:[error.userInfo JSONString]];
    }else{
        NSLog(@"发送数据成功");
//        [self updateLog:@"发送数据成功"];
    }
    
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    NSLog(@"===%@",characteristic);
    
//    [peripheral readValueForCharacteristic:characteristic];
}

@end
