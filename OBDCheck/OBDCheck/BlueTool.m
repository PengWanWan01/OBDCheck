//
//  BlueTool.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/24.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "BlueTool.h"

@implementation BlueTool
+(CGFloat)getRotational:(CGFloat)value with:(CGFloat)nextvalue{
    return value*64+nextvalue*63.75/255;
}
+(CGFloat)getVehicleSpeed:(CGFloat)value{
    return value;
}
+(CGFloat)getWatertemperature:(CGFloat)value{
    return value-40;
    
}
+(CGFloat)getThrottlePosition:(CGFloat)value{
    return value*100/255;
}
+(NSString * )isWatertemperature:(NSString *)string{
     NSString * resultVehicleSpeed= nil ;
    switch ([DashboardSetting sharedInstance].protocolType) {
        case CanProtocol:
            {
                
            }
            break;
        case KWProtocol:
        {
            if (string.length>14 && [[string substringToIndex:8] isEqualToString:@"83F11141"]){
                //得到水温
                NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
                CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
                //水温添加到数组
                if ([Commond isEqualToString:@"05"]) {
                    resultVehicleSpeed = [NSString stringWithFormat:@"%.f",[BlueTool getWatertemperature:thefloat]];
                }
            }
        }
            break;
        default:
            break;
    }
     return resultVehicleSpeed;
}
+(NSString *)isRotational:(NSString *)string{
     NSString * resultVehicleSpeed = nil;
    switch ([DashboardSetting sharedInstance].protocolType) {
        case CanProtocol:
        {
            
        }
            break;
        case KWProtocol:
        {
            if (string.length>16 && [[string substringToIndex:8] isEqualToString:@"84F11141"]){
                NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
                CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
                CGFloat theNextfloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(12, 2)]]floatValue];
                //转速添加到数组
                if ([Commond isEqualToString:@"0C"]) {
                    resultVehicleSpeed = [NSString stringWithFormat:@"%.f",[BlueTool getRotational:thefloat with:theNextfloat]];
                }
            }
        }
            break;
        default:
            break;
    }
     return resultVehicleSpeed;
}
+(NSString *)isVehicleSpeed:(NSString *)string{
    NSString * resultVehicleSpeed = nil ;
    switch ([DashboardSetting sharedInstance].protocolType) {
        case CanProtocol:
        {
            
        }
            break;
        case KWProtocol:
        {
            if (string.length>14 && [[string substringToIndex:8] isEqualToString:@"83F11141"]){
                
                NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
                CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
                //车速添加到数组
                if ([Commond isEqualToString:@"0D"]) {
                resultVehicleSpeed = [NSString stringWithFormat:@"%.f",[BlueTool getVehicleSpeed:thefloat]];
                }
            }
        }
            break;
        default:
            break;
    }
    return resultVehicleSpeed;
}
+(NSString *)isThrottlePosition:(NSString *)string{
     NSString * resultVehicleSpeed = nil;
    switch ([DashboardSetting sharedInstance].protocolType) {
        case CanProtocol:
        {
            
        }
            break;
        case KWProtocol:
        {
            if (string.length>14 && [[string substringToIndex:8] isEqualToString:@"83F11141"]){
                //得到TF
                NSString* Commond = [string substringWithRange:NSMakeRange(8, 2)];
                CGFloat thefloat = [[BlueTool numberHexString:[string substringWithRange:NSMakeRange(10, 2)]]floatValue];
                //TF添加到数组
                if ([Commond isEqualToString:@"11"]) {
                 resultVehicleSpeed =    [NSString stringWithFormat:@"%.f",[BlueTool getThrottlePosition:thefloat]];
                }
            }
        }
            break;
        default:
            break;
    }
     return resultVehicleSpeed;
}
#pragma mark 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
    
}
+(NSData*) hexToBytes :(NSString*)hex{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hex.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hex substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
#pragma mark 16进制变为二进制
+ (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}
#pragma mark 二进制变为十六进制
+ (NSString *)getHexByBinary:(NSString *)binary {
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}


#pragma mark 二进制变为十进制
+ (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}
@end
