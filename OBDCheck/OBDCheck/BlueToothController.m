//
//  BlueToothController.m
//  CarApp－ByMe
//
//  Created by apple on 15/7/2.
//  Copyright (c) 2015年 com.Autophix.T100. All rights reserved.
//

#define BLUENAME @"V100"

#define BLUE_SERVER @"FFE0"
#define BLUE_CHARACTERISTIC_READ @"FFE1"
#define BLUE_CHARACTERISTIC_WRITE @"FFE1"

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
    
    
    //设置文件
     XYRunSetting * RunSetting;
    
    //4.0适应控制器
    XYData* Mydata;
    
    //是否连接到蓝牙的计时器
    NSTimer* timer;
    
    
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
        
        //初始化设置文件
        RunSetting = [XYRunSetting Instance];
        
        
    }
        return self;
}

//查询到状态时调用的函数
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            //状态是好的的时候，记录本地设置文件蓝牙启动为yes
            [RunSetting SetAttribute:@"yes" Key:XYRunSettingAttributeUpBlueTooth];
            //先初始化连接状态为no
            [RunSetting SetAttribute:@"no" Key:XYRunSettingAttributeIsConnect];
            
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
            [RunSetting SetAttribute:@"no" Key:XYRunSettingAttributeUpBlueTooth];
            NSLog(@"设备存在问题，无法搜索蓝牙~");
            break;
    }
}


//读取RSSI值
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    if (self.delegate) {
        if ([[self.delegate class] instancesRespondToSelector:@selector(GetRSSI:)]) {
            [self.delegate GetRSSI:[RSSI doubleValue]];
        }
        
    }
}

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
-(BOOL)saveBLE:(BELInfo*)info
{
    NSLog(@"发现设备%@:%@",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
    
    //如果名字为Autophix，则连接并且保存返回yes
    if (/*[info.discoveredPeripheral.name isEqualToString:BLUENAME]*/[OEM isValidateName:info.discoveredPeripheral.name]) {
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

//连接蓝牙函数
-(BOOL)ConnectBlueTooth:(CBPeripheral*)pheral
{
    //连接蓝牙设备
    [self.centralMgr connectPeripheral:pheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
    //记录连接的蓝牙,并且设置该外围设备协议
    self.ConnectPeripheral = pheral;
    [pheral setDelegate:self];
    return YES;
}

//连接蓝牙的时候触发的协议函数
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

//没连上的时候的响应函数
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
    //显示吐司
    Toast* toast = [Toast makeText:NSLocalizedString(@"您的蓝牙已断开连接，正在尝试重新为您连接设备...", @"")];
    [toast showWithType:LongTime];
    //清除之前保存的所有信息
    [self.arrayBLE removeAllObjects];
    SendCharacteristic = nil;
    ReadCharacteristic = nil;
    
    MyServer = nil;
    //设置文件变为no
    [RunSetting SetAttribute:@"no" Key:XYRunSettingAttributeIsConnect];
    
    //重新搜索
    [self Scan];
    //开启计时器50秒内没有连接到蓝牙设备，停止搜索
    timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(BLStopScan) userInfo:nil repeats:NO];
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
   
    NSLog(@"通知%@",characteristic.value );
}

-(void)Scan
{
    Toast* toast = [Toast makeText:NSLocalizedString(@"开始搜索附近的设备", @"")];
    [toast showWithType:LongTime];
    
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

//停止搜索
-(void)BLStopScan
{
    [self.centralMgr stopScan];
    //显示吐司
    Toast* toast = [Toast makeText:NSLocalizedString(@"蓝牙搜索已停止，如需搜索请点击开始连接按钮", @"")];
    [toast showWithType:LongTime];
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

//搜索服务的时候触发的协议函数
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
//扫描完每一个特征值之后调用该函数
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        //扫描每一个特征
        for (CBCharacteristic* character in service.characteristics) {
            
            NSLog(@"搜索到一个特征：%@",character.UUID.UUIDString);
            
            //如果是写的特征，写入发送特征对象中
            if ([character.UUID.UUIDString isEqualToString:BLUE_CHARACTERISTIC_WRITE]) {
                 NSLog(@"可以写入呀");
                SendCharacteristic = character;
            }
            //如果是读特征，写入读特征对象中
            if ([character.UUID.UUIDString isEqualToString:BLUE_CHARACTERISTIC_READ]) {
//                ReadCharacteristic = character;
              
                //绑定监听
                NSLog(@"可以读取呀");
                [self.ConnectPeripheral setNotifyValue:YES forCharacteristic:character];
            
            
            }
        }
        //特征值全部扫描完成时，设置文件中连接状态为yes
        [RunSetting SetAttribute:@"yes" Key:XYRunSettingAttributeIsConnect];
        //显示吐司
        Toast* toast = [Toast makeText:NSLocalizedString(@"蓝牙连接成功！请放心使用！", @"")];
        [toast showWithType:LongTime];
        //调用协议
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

//通过特征值发送数据
-(void)SendData:(NSData*)data
{
//    NSLog(@"开启了一个线程发送数据：%@",data);
    
//    NSThread* SendThread = [[NSThread alloc] initWithTarget:self selector:@selector(SenddataByOtherWay:) object:data];
//
//    
//    
//    [SendThread start];

    NSLog(@"1发出数据：%@",data);
    //需要响应的发送数据
    if (SendCharacteristic) {
        [self.ConnectPeripheral writeValue:data forCharacteristic:SendCharacteristic type:CBCharacteristicWriteWithoutResponse];
        // CBCharacteristicWriteWithResponse
    }
    
}


//发送数据线程
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

//监听读特征的协议函数

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData* data = characteristic.value;
    NSLog(@"收到了一条源数据：%@",data);
    
    //    用来处理蓝牙4.0
    
    //获取头
    NSString* dataStr = [XHConvertUtil bytesToHexString:data];
    //大于4继续，否则直接询问拼接
    if (dataStr.length <= 4) {
        goto ForNil;
    }
    else
    {
        if ([[dataStr substringToIndex:4] isEqualToString:AUTOPHIX_DATA_HEAD]) {
            
            NSInteger Length = [XHConvertUtil hexToInt:[dataStr substringWithRange:NSMakeRange(4, 2)]];
            if (Length>17) {
            
                Mydata = [[XYData alloc] initWithHeadString:dataStr];
                return;
                
            }
            else
            {
                
            PassToDeletage:
                data = [XHConvertUtil hexStringToBytes:dataStr];
                //调用协议的函数
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(BlueToothEventWithReadData:Data:)]) {
                        [self.delegate BlueToothEventWithReadData:peripheral Data:data];
                    }
                    
                }
                
                //清空缓冲区
                Mydata = nil;
                
                //处理完成数据后，开启信号灯
                [condition signal];
                return;
            }
            
        }
        else
        {
        ForNil:
            if (!Mydata) {
                return;
            }
            else
            {
                [Mydata AppendString:dataStr];
                dataStr = [Mydata IsOverForGet];
                if (dataStr) {
                    goto PassToDeletage;
                }
                else
                {
                    return;
                }
            }
        }
    }
//    NSString* headStr = ;
//    //
//    //如果储存的字符串为空，且头不是55aa的时候，直接返回不作处理
//    if ([[Mydata getMydata] isEqualToString:@""]&&![headStr isEqualToString:@"55aa"]) {
//        
//    }
//    else
//    {
//        //如果一个包装不下，拼接字符串
//        if (!Mydata) {
//            Mydata = [[XYData alloc] initWithData:data];
//        }
//        data = [Mydata AddData:data];
//        if (!data) {
//            NSLog(@"数据未接收完全");
//            return;
//        }
//    }
//    NSLog(@"最后得到的数据：%@",data);
    
}

//断开连接
-(void)DisConnectBlueTooth
{
    self.ConnectPeripheral.delegate = nil;
    [self.centralMgr cancelPeripheralConnection:self.ConnectPeripheral];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"发出了一条数据");
}

@end
