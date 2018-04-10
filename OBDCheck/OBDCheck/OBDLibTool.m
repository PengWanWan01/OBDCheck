//
//  OBDLibTool.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/9.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "OBDLibTool.h"
@interface OBDLibTool()<BlueToothControllerDelegate>

@end
@implementation OBDLibTool
+ (instancetype)sharedInstance {
    static OBDLibTool *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OBDLibTool alloc] init];
        
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
        self.sendData = [[NSData alloc]init];
        self.totalData = [[NSData alloc]init];
        self.resolveData = [[NSData alloc]init];
        self.backData = [[NSData alloc]init];
        Byte byte1[] = {0x00};  //请求指令
        self.input = [NSData dataWithBytes:byte1 length: CmdDataSetSize];//输入的缓冲区的大小必须是CmdDataSetSize
        self.output = [NSData dataWithBytes:byte1 length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
    }
    return self;
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
        DLog(@"得到的设备信息%@:%@",info.discoveredPeripheral.name,info.discoveredPeripheral.identifier.UUIDString);
    }
}
-(void)BlueToothEventWithReadData:(CBPeripheral *)peripheral Data:(NSData *)data
{
   
}
#pragma mark 得到蓝牙连接状态
-(void)BlueToothState:(BlueToothState)state{

}
- (void)InitTool{
    Byte *byt = (Byte *)[[BlueTool hexToBytes:@"02000181"] bytes];
    self.input = [NSData dataWithBytes:byt length: CmdDataSetSize];//输入的缓冲区的大小必须是CmdDataSetSize
    self.output = [NSData dataWithBytes:byt length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
    [self PrsCmdLoadDataOCInput:self.input withOutPut:self.output];
    while (1) {
        //判断第2个字节为01/02/03/04/05/06
        NSData *anwerData = [self.output subdataWithRange:NSMakeRange(2, 1)];
        DLog(@"输出%@",self.output);
        DLog(@"libk库里面的相应%@",anwerData);
        Byte *anwerByte = (Byte *)[anwerData bytes];
        int aqq = [self lBytesToInt:anwerByte];
        //
        NSData *LengthData = [self.output subdataWithRange:NSMakeRange(4, 1)];
        Byte *testByte = (Byte *)[LengthData bytes];
        int a = [self lBytesToInt:testByte];
        
        switch (aqq) {
            case 1:
                {
                    //得到蓝牙发送指令（第3个字节，到预计的长度）进行发送；取得得到的蓝牙返回数据
                    [self ComSendRead:20000 SendBuf:[self.output subdataWithRange:NSMakeRange(5, a)] ReadBufP:self.backData];
                    //得到拼接内容
                    NSMutableData *F1data =[[NSMutableData alloc]initWithData:[BlueTool hexToBytes:@"02000281"]];;
                    [F1data appendData:self.backData];
                    self.backData = [[NSData alloc]init];
                    DLog(@"**%@",F1data);
                    Byte *testByte = (Byte *)[F1data bytes];
                    NSData *inputData = [NSData dataWithBytes:testByte length:CmdDataSetSize];
                    Byte byte[] = {0x00};
                    self.output = [NSData dataWithBytes:byte length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
                    [self PrsCmdLoadDataOCInput:inputData withOutPut:self.output];

                }
                break;
            case    2://请求显示数据
                return ;
            case    3://下位机肯定应答
                self.EnterSuccess = YES;
                DLog(@"进入成功");
                return ;
            case    4://下位机否定应答，已经与汽车断开连接
                return ;
            case    5://下位机否定应答，处于忙状态，请重新接收数据（等待5S）
            {  [self ComRead:6000];
                //得到拼接内容
                NSMutableData *F1data =[[NSMutableData alloc]initWithData:[BlueTool hexToBytes:@"02000281"]];;
                [F1data appendData:self.backData];
                DLog(@"**%@",F1data);
                Byte *testByte = (Byte *)[F1data bytes];
                NSData *inputData = [NSData dataWithBytes:testByte length:CmdDataSetSize];
                Byte byte[] = {0x00};
                self.output = [NSData dataWithBytes:byte length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
                [self PrsCmdLoadDataOCInput:inputData withOutPut:self.output];
            }
                break;
            case    6://下位机否定应答，不识别的指令或数据
                return ;
            default:
                break;
        }
    }
}
- (void)OBDIIReadDTC:(NSString *)str{
   //01读取存储故障码  02读取未决故障码 03 读取历史故障码
    Byte *byt = (Byte *)[[BlueTool hexToBytes:str] bytes];
    self.input = [NSData dataWithBytes:byt length: CmdDataSetSize];//输入的缓冲区的大小必须是CmdDataSetSize
    self.output = [NSData dataWithBytes:byt length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
    [self PrsCmdLoadDataOCInput:self.input withOutPut:self.output];
    int  Flag = 1;
    while (Flag) {
        //判断第2个字节为01/02/03/04/05/06
        NSData *anwerData = [self.output subdataWithRange:NSMakeRange(2, 1)];
        DLog(@"输出%@",self.output);
        DLog(@"libk库里面的相应%@",anwerData);
        Byte *anwerByte = (Byte *)[anwerData bytes];
        int aqq = [self lBytesToInt:anwerByte];
        //
        NSData *LengthData = [self.output subdataWithRange:NSMakeRange(4, 1)];
        Byte *testByte = (Byte *)[LengthData bytes];
        int a = [self lBytesToInt:testByte];
        
        switch (aqq) {
            case 1:
            {
                //得到蓝牙发送指令（第3个字节，到预计的长度）进行发送；取得得到的蓝牙返回数据
                [self ComSendRead:20000 SendBuf:[self.output subdataWithRange:NSMakeRange(5, a)] ReadBufP:self.backData];
                //得到拼接内容
                NSMutableData *F1data =[[NSMutableData alloc]initWithData:[BlueTool hexToBytes:@"02000201"]];;
                [F1data appendData:self.backData];
                self.backData = [[NSData alloc]init];
                DLog(@"**%@",F1data);
                Byte *testByte = (Byte *)[F1data bytes];
                NSData *inputData = [NSData dataWithBytes:testByte length:CmdDataSetSize];
                Byte byte[] = {0x00};
                self.output = [NSData dataWithBytes:byte length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
                [self PrsCmdLoadDataOCInput:inputData withOutPut:self.output];
                
            }
                break;
            case    2://请求显示数据
             Flag = 0;
          DLog(@"获取的故障码为%@",[[NSString alloc] initWithData:[self.output subdataWithRange:NSMakeRange(5, self.output.length - 5)]  encoding:NSUTF8StringEncoding]);
                
                return ;
            case    3://下位机肯定应答
                 Flag = 0;
                break ;
            case    4://下位机否定应答，已经与汽车断开连接
                return ;
            case    5://下位机否定应答，处于忙状态，请重新接收数据（等待5S）
            {  [self ComRead:6000];
                //得到拼接内容
                NSMutableData *F1data =[[NSMutableData alloc]initWithData:[BlueTool hexToBytes:@"02000201"]];;
                [F1data appendData:self.backData];
                DLog(@"**%@",F1data);
                Byte *testByte = (Byte *)[F1data bytes];
                NSData *inputData = [NSData dataWithBytes:testByte length:CmdDataSetSize];
                Byte byte[] = {0x00};
                self.output = [NSData dataWithBytes:byte length: CmdDataSetSize];//输出的缓冲区的大小必须是CmdDataSetSize
                [self PrsCmdLoadDataOCInput:inputData withOutPut:self.output];
            }
                break;
            case    6://下位机否定应答，不识别的指令或数据
                return ;
            case    7://NOdata
                Flag = 0;
                break ;
            default:
                break;
        }
    }
}
- (void)ComSendRead:(int )iMaxWaitTime SendBuf:(NSData *)Senddata ReadBufP:(NSData *)Readdata{
    
    [self.blueTooth SendData:Senddata];
    self.backData = nil;
    [self ComRead:iMaxWaitTime];
}
- (void)ComRead:(int )iMaxWaitTime{
    //得到蓝牙返回数据内容处理；
//    得到蓝牙返回数据
//    time_t EndTime;
//    EndTime = iMaxWaitTime + clock();
//    while (EndTime>clock())
//    {
//          EndTime = 50 + clock();//帧间最大50mS
//        if ((self.backData.length>3)&& ([[self.backData subdataWithRange:NSMakeRange(self.backData.length -3, 3)] isEqualToData:[BlueTool hexToBytes:@"odod3e"]])) {
//            DLog(@"返回结束");
//        }
//         DLog(@"得到蓝牙返回数据%@",self.backData)
//    }
    while (1) {
       
        if (!(self.backData == nil)) {
            if ((self.backData.length>3)&& ([[self.backData subdataWithRange:NSMakeRange(self.backData.length -3, 3)] isEqualToData:[BlueTool hexToBytes:@"0d0d3e"]])) {
                DLog(@"不为空%@",self.backData );
            return;
            }
        }
    }
    
}
@end
