//
//  BlueTool.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/24.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueTool : NSObject
@property (nonatomic,copy) NSString *CanHeadIDStr;
+(CGFloat)getWatertemperature:(CGFloat)value;
+(CGFloat)getVehicleSpeed:(CGFloat)value;
+(CGFloat)getThrottlePosition:(CGFloat)value;
+(CGFloat)getRotational:(CGFloat)value with:(CGFloat)nextvalue;
+ (NSNumber *) numberHexString:(NSString *)aHexString;
+(NSData*) hexToBytes :(NSString*)hex;
+ (NSInteger)getDecimalByBinary:(NSString *)binary;
+ (NSString *)getBinaryByHex:(NSString *)hex;
+ (NSString *)getHexByBinary:(NSString *)binary ;
+(NSString *)isWatertemperature:(NSString *)string;//水温
+(NSString *)isRotational:(NSString *)string;  //转速
+(NSString *)isVehicleSpeed:(NSString *)string;  //车速
+(NSString *)isThrottlePosition:(NSString *)string; //TF 
+(NSString *)istroubleCode03:(NSString *)string; //03故障码
+(NSString *)istroubleCode07:(NSString *)string; //07故障码
+(NSString *)istroubleCode0a:(NSString *)string; //0a故障码
+ (NSString *)getcode:(NSString *)str;
@end
