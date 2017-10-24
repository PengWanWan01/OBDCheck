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
// 16进制转10进制
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

@end
