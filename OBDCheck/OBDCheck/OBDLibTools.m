//
//  OBDLibTools.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/9.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "OBDLibTools.h"
 Byte inputData[CmdDataSetSize];
 Byte outputData[CmdDataSetSize];
 Byte StreamDataPID[CmdDataSetSize];

@interface OBDLibTools()<BlueToothControllerDelegate>

@end
@implementation OBDLibTools
+ (instancetype)sharedInstance {
    static OBDLibTools *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OBDLibTools alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.blueTooth = [BlueToothController Instance];
        self.blueTooth.delegate = self;
        self.LoadSuccess = NO;
        self.EnterSuccess = NO;
        self.backData = [[NSData alloc]init];
        self.PIDNum = 0;
        }
    return self;
}


#pragma mark 收发
- (void)SendMessageAndWaitLibThread:(int )mS{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"Tag", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"send" object:nil userInfo:dict];
    if (mS ) {
        while ((!([OBDLibTools sharedInstance].MessageVal == 1)) && (mS)) {//等待库线程处理完成
            sleep(1);//节约CPU资源
        }
    }else{
        while (!([OBDLibTools sharedInstance].MessageVal == 1)) {//等待库线程处理完成
            sleep(1);//节约CPU资源
        }
    }
    
}
-(int) lBytesToInt:(Byte[]) b
{
    int s = 0;
    for (int i = 0; i < 3; i++)
    {
        if (b[3-i] >= 0)
        {
            s = s + b[3-i];
        } else
        {
            s = s + 256 + b[3-i];
        }
        s = s * 256;
    }
    if (b[0] >= 0)
    {
        s = s + b[0];
    } else {
        s = s + 256 + b[0];
    }
    return s;
}
//代理协议，处理信息
- (void)getDeviceInfo:(BELInfo *)info{
    
    if (!(info.discoveredPeripheral.name == nil)) {
        if (@available(iOS 7.0, *)) {
            DLog(@"得到的设备信息%@:%@",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
        } else {
            // Fallback on earlier versions
        }
    }
}
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
   
}
#pragma mark 得到蓝牙连接状态
-(void)BlueToothState:(BlueToothState)state{

}
- (void)InitTool{
    inputData[0] = 0x02;
      inputData[1] = 0x00;
      inputData[2] = 0x01;
      inputData[3] = 0x81;
    [self SendMessageAndWaitLibThread:0];

    while (1) {
        NSData *outdata = [NSData dataWithBytes:outputData length:CmdDataSetSize];
        DLog(@"拼接之后output***%@",outdata);
        //判断第2个字节为01/02/03/04/05/06
        NSData *anwerData = [outdata subdataWithRange:NSMakeRange(2, 1)];
        DLog(@"libk库里面的相应%@",anwerData);
        Byte *anwerByte = (Byte *)[anwerData bytes];
        int aqq = [self lBytesToInt:anwerByte];
        //
        NSData *LengthData = [outdata subdataWithRange:NSMakeRange(4, 1)];
        Byte *testByte = (Byte *)[LengthData bytes];
        int a = [self lBytesToInt:testByte];
        NSLog(@"5555555555555555555");
        switch (aqq) {
            case 1:
                {
                    //得到蓝牙发送指令（第3个字节，到预计的长度）进行发送；取得得到的蓝牙返回数据
                    [self ComSendRead:20000 SendBuf:[outdata subdataWithRange:NSMakeRange(5, a)] ReadBufP:4 ];
                      inputData[0] = 0x02;//OBD
                      inputData[1] = 0x00;
                      inputData[2] = 0x02;//请求数据
                      inputData[3] = 0x81;//进入
                    NSData *indata = [NSData dataWithBytes:inputData length:CmdDataSetSize];
                    DLog(@"拼接之后的inputData%@",indata);
                    [self SendMessageAndWaitLibThread:0];
                    
                }
                break;
            case    2://请求显示数据
                return ;
            case    3://下位机肯定应答
                self.EnterSuccess = YES;
                DLog(@"进入成功");
                dispatch_async(dispatch_get_main_queue(), ^{
//                  [SVProgressHUD showInfoWithStatus:@"进入成功"];
                });
//
                return ;
            case    4://下位机否定应答，已经与汽车断开连接
                return ;
            case    5://下位机否定应答，处于忙状态，请重新接收数据（等待5S）
            {
                [self ComRead:6000 ReadBufP:4];
                //得到头
                inputData[0] = 0x02;//OBD
                inputData[1] = 0x00;
                inputData[2] = 0x02;//请求数据
                inputData[3] = 0x81;//进入
                [self SendMessageAndWaitLibThread:0];
            }
                break;
            case    6://下位机否定应答，不识别的指令或数据
                return ;
            default:
                break;
        }
    }

}
//
- (void)OBDIIReadDTC:(NSString *)str{
//    self.troubleCodeArray = nil;
//    self.explainCodeArray = nil;
    Byte *byt = (Byte *)[[BlueTool hexToBytes:str] bytes];
    for (NSInteger i = 0; i < str.length/2; i++) {
        inputData[i] = byt[i];
    }
        [self SendMessageAndWaitLibThread:0];
    int  Flag = 1;
    while (Flag) {
        NSData *outdata = [NSData dataWithBytes:outputData length:CmdDataSetSize];
        NSData *LengthData = [outdata subdataWithRange:NSMakeRange(4, 1)];
        Byte *testByte = (Byte *)[LengthData bytes];
        int a = [self lBytesToInt:testByte];
        
        switch (outputData[2]) {
            case 0x01:
            {
                //得到蓝牙发送指令（第3个字节，到预计的长度）进行发送；取得得到的蓝牙返回数据
                [self ComSendRead:20000 SendBuf:[outdata subdataWithRange:NSMakeRange(5, a)] ReadBufP:4];
                //得到拼接内容
               inputData[0] = 0x02;//OBD
                inputData[2] = 0x00;
               inputData[2] = 0x02;//请求数据
                inputData[3] = 0x01;//读取故障码
                [self SendMessageAndWaitLibThread:0];
            }
                break;
            case    0x02://请求显示数据
            {
             Flag = 0;
                //01读取存储故障码  02读取未决故障码 03 读取历史故障码
                if (a>0) {
                    //得到一串所有的故障码字符串
                    NSString *resultStr = [[NSString alloc] initWithData:[outdata subdataWithRange:NSMakeRange(5,5*a)]  encoding:NSUTF8StringEncoding];
                    DLog(@"获取所有的故障码为%@",resultStr);
                    for (NSInteger i = 0; i<a; i++) { //得到一个5个数的故障码
                        NSString *toubleCodeStr =  [resultStr  substringWithRange:NSMakeRange(5*i, 5)];
                        DLog(@"获取的故障码名称为%@",toubleCodeStr);
                        NSMutableDictionary  *dict = [NSMutableDictionary dictionary];
                        if ([str isEqualToString:@"0200010101"]) {
                            [dict setObject:toubleCodeStr forKey:@"important"];
                            [self FindTroubleCodeMean:toubleCodeStr withKey:@"important"];
                        }else if([str isEqualToString:@"0200010102"]){
                            [dict setObject:toubleCodeStr forKey:@"total"];
                            [self FindTroubleCodeMean:toubleCodeStr withKey:@"total"];
                        }else if([str isEqualToString:@"0200010103"]){
                            [dict setObject:toubleCodeStr forKey:@"total"];
                            [self FindTroubleCodeMean:toubleCodeStr withKey:@"total"];
                        }
                        DLog(@"获取的故障码字典为%@",dict);
                            [self.troubleCodeArray addObject: dict];
                         DLog(@"获取的故障码数组为%@",self.troubleCodeArray);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 通知主线程刷新
                              [[NSNotificationCenter defaultCenter]postNotificationName:@"readTroubleCode" object:nil userInfo:nil];
                        });
                      
                    }
                }
            }
                return ;
            case    0x03://下位机肯定应答
                 Flag = 0;
                break ;
            case   0x04://下位机否定应答，已经与汽车断开连接
                return ;
            case    0x05://下位机否定应答，处于忙状态，请重新接收数据（等待5S）
            {  [self ComRead:6000 ReadBufP:4];
                //得到拼接内容头
                inputData[0] = 0x02;//OBD
                inputData[1] = 0x00;
               inputData[2] = 0x02;//请求数据
                inputData[4] = 0x01;//读取故障码
                [self SendMessageAndWaitLibThread:0];
            }
                break;
            case    0x06://下位机否定应答，不识别的指令或数据
                return ;
            case    0x07://NOdata
                Flag = 0;
                break ;
            default:
                break;
        }
    }
}
- (void)OBDIIDataStream{
   
    Byte *byt = (Byte *)[[BlueTool hexToBytes:@"020001030000"] bytes];
    for (NSInteger i = 0; i < 6; i++) {
        inputData[i] = byt[i];
    }
    [self SendMessageAndWaitLibThread:0];
    int  Flag = 1;
    while (Flag) {
        NSData *outdata = [NSData dataWithBytes:outputData length:CmdDataSetSize];
        DLog(@"PID拼接之后output***%@",outdata);
        //判断第2个字节为01/02/03/04/05/06
        NSData *anwerData = [outdata subdataWithRange:NSMakeRange(2, 1)];
        DLog(@"libk库里面的相应%@",anwerData);
        Byte *anwerByte = (Byte *)[anwerData bytes];
        int aqq = [self lBytesToInt:anwerByte];
        //
        NSData *LengthData = [outdata subdataWithRange:NSMakeRange(4, 1)];
        Byte *testByte = (Byte *)[LengthData bytes];
        int a = [self lBytesToInt:testByte];
        switch (aqq) {
            case 1:
                {
                    //得到蓝牙发送指令（第3个字节，到预计的长度）进行发送；取得得到的蓝牙返回数据
                    [self ComSendRead:20000 SendBuf:[outdata subdataWithRange:NSMakeRange(5, a)] ReadBufP:6];
                    //得到拼接内容
                    inputData[0] = 0x02;//OBD
                     inputData[1] = 0x00;
                    inputData[2]= 0x02;//请求数据
                    inputData[3] = 0x03;//读取数据流
                     inputData[4] = 0x00;//获取PID序号的指令：0000的高字节
                     inputData[5] = 0x00;//获取PID序号的指令：0000的低字节
                    [self SendMessageAndWaitLibThread:0];
                }
                break;
            case 2://请求显示数据
            {
                DLog(@"%@",outdata);
              self.PIDNum =   (outputData[6] << 8) + outputData[7];
                
                DLog(@"个数%ld",(long)self.PIDNum);
                if (self.PIDNum == 0) {
                    return;
                }
                for (NSInteger i = 0; i <self.PIDNum; i++){
                    StreamDataPID[i] = (outputData[8+i*2] << 8) + outputData[9+i*2];
                }
                 Flag = 0;
            }
                break;
            case 3://下位机肯定应答
            {
                  Flag = 0;
            }
                break;
            case 4: //下位机否定应答，已经与汽车断开连接
            {
                
            }
                return ;
            case 5: //下位机否定应答，处于忙状态，请重新接收数据（等待5S）
            {
                [self ComRead:6000 ReadBufP:6];
                //得到拼接内容
                inputData[0] = 0x02;//OBD
               inputData[1] = 0x00;
                inputData[2] = 0x02;//请求数据
                inputData[3] = 0x03;//读取数据流
               inputData[4] = 0x00;//获取PID序号的指令：0000的高字节
               inputData[5] = 0x00;//获取PID序号的指令：0000的低字节
                [self SendMessageAndWaitLibThread:0];
            }
                break;
            case 6://下位机否定应答，不识别的指令或数据
            {
               
            }
                return;
            case 7:
            {
               Flag = 0;
            }
                break;
            default:
                break;
        }
    }
    
    [self OBDIIDataStreamPID];
    
}
- (void)OBDIIDataStreamPID{
    DLog(@"数据路数据流");
    while(1){
    //读取相应的ECU支持的PID的数据
    for (unsigned int i = 0; i < self.PIDNum; i++)
    {
        inputData[0] = 0x02;//OBD
        inputData[1] = 0x00;
        inputData[2]  = 0x01;//请求指令
        inputData[3]  = 0x03;//读取数据流
        inputData[4]  = (StreamDataPID[i]>>8)&0xff;//获取PID序号的指令：xxxx的高字节
        inputData[5]  = StreamDataPID[i]&0xff;//获取PID序号的指令：xxxx的低字节
        [self SendMessageAndWaitLibThread:0];
        char Flag = 1;
        while (Flag)
        {
            NSData *outdata = [NSData dataWithBytes:outputData length:CmdDataSetSize];
            DLog(@"PID拼接之后output***%@",outdata);
            //判断第2个字节为01/02/03/04/05/06
            NSData *anwerData = [outdata subdataWithRange:NSMakeRange(2, 1)];
            DLog(@"libk库里面的相应%@",anwerData);
            Byte *anwerByte = (Byte *)[anwerData bytes];
            int aqq = [self lBytesToInt:anwerByte];
            //
            NSData *LengthData = [outdata subdataWithRange:NSMakeRange(4, 1)];
            Byte *testByte = (Byte *)[LengthData bytes];
            int a = [self lBytesToInt:testByte];
            switch (aqq)
            {
                case    0x01://请求发送数据
                    //得到蓝牙发送指令（第3个字节，到预计的长度）进行发送；取得得到的蓝牙返回数据
                    [self ComSendRead:20000 SendBuf:[outdata subdataWithRange:NSMakeRange(5, a)] ReadBufP:6];
                    //拼接头内容
                    inputData[0] = 0x02;//OBD
                    inputData[1] = 0x00;
                    inputData[2] = 0x02;//请求数据
                    inputData[3] = 0x03;//读取数据流
                    inputData[4] = (StreamDataPID[i] >> 8) & 0xff;//获取PID序号的指令：xxxx的高字节
                    inputData[5] = StreamDataPID[i] & 0xff;//获取PID序号的指令：xxxx的低字节
                    [self SendMessageAndWaitLibThread:0];
                    
                    break;
                case    0x02://请求显示数据
                    //转为Str;
                    DLog(@"%@",[[NSString alloc]initWithData:outdata encoding:NSUTF8StringEncoding]);
                    Flag = 0;
                    break;
                case    0x03://下位机肯定应答
                    Flag = 0;
                    break;
                case    0x04://下位机否定应答，已经与汽车断开连接
                    return ;
                case    0x05://下位机否定应答，处于忙状态，请重新接收数据（等待5S）
                    [self ComRead:6000 ReadBufP:6];
                    inputData[0] = 0x02;//OBD
                    inputData[1] = 0x00;
                    inputData[2] = 0x02;//请求数据
                    inputData[3] = 0x03;//读取数据流
                    inputData[4] = (StreamDataPID[i] >> 8) & 0xff;//获取PID序号的指令：xxxx的高字节
                    inputData[5] = StreamDataPID[i] & 0xff;//获取PID序号的指令：xxxx的低字节
                    [self SendMessageAndWaitLibThread:0];
                    break;
                case    0x06://下位机否定应答，不识别的指令或数据
                    return ;
                case    0x07:
                    return ;
                default:
                    return ;
            }
        }
    }
    }
}
- (void)ComSendRead:(int )iMaxWaitTime SendBuf:(NSData *)Senddata ReadBufP:(NSInteger )Location{
    [self.blueTooth SendData:Senddata];
    [self ComRead:iMaxWaitTime ReadBufP:Location];
}

#pragma mark 拼接蓝牙返回内容
- (void)ComRead:(int )iMaxWaitTime ReadBufP:(NSInteger)Location{
//    得到蓝牙返回数据
    while (1) {
//        DLog(@"蓝牙返回数据%@",self.backData);
        if (!(self.backData == nil)) {
            if (self.backData.length>=3) {
                int i = (int)self.backData.length - 3;
                NSData *test = [self.backData subdataWithRange:NSMakeRange(i, 3)];
                if ([test isEqualToData:[BlueTool hexToBytes:@"0d0d3e"]]) {
                     DLog(@"不为空%@",self.backData );
                    Byte *pinbyte = (Byte *)[self.backData bytes];
                    for (NSInteger  i = 0; i<self.backData.length; i++) {
                        inputData[Location +i] = pinbyte[i];
                    }
                    self.backData = nil;
                      return;
                }
            }
        }
    }
}

//查找故障码解释
-(void)FindTroubleCodeMean:(NSString *)str withKey:(NSString *)Key{
    NSMutableData *F1data =[[NSMutableData alloc]initWithData:[BlueTool hexToBytes:@"020002830000"]];;
    [F1data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    DLog(@"**%@",F1data);
    Byte *testByte = (Byte *)[F1data bytes];
    for (NSInteger i = 0; i < F1data.length; i++) {
        inputData[i] = testByte[i];
    }
    
    [self SendMessageAndWaitLibThread:0];
    //添加故障码的解释保持到数组
    NSData *outdata = [NSData dataWithBytes:outputData length:CmdDataSetSize];
    DLog(@"拼接之后output***%@",outdata);
    DLog(@"%@",[[NSString alloc]initWithData:outdata encoding:NSUTF8StringEncoding])
    NSMutableDictionary  *dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSString alloc]initWithData:outdata encoding:NSUTF8StringEncoding] forKey:Key];
    [self.explainCodeArray addObject:dict];
    DLog(@"解释数组%@",self.explainCodeArray);

}

- (void)OBDIIReadDTC{
    self.troubleCodeArray = [[NSMutableArray alloc]init];
    self.explainCodeArray = [[NSMutableArray alloc]init];
    [[OBDLibTools sharedInstance] OBDIIReadDTC:@"0200010101"];
    [[OBDLibTools sharedInstance] OBDIIReadDTC:@"0200010102"];
    [[OBDLibTools sharedInstance] OBDIIReadDTC:@"0200010103"];
}

@end
