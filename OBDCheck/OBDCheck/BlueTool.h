//
//  BlueTool.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/24.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueTool : NSObject

+(CGFloat)getWatertemperature:(CGFloat)value;
+(CGFloat)getVehicleSpeed:(CGFloat)value;
+(CGFloat)getRotational:(CGFloat)value with:(CGFloat)nextvalue;
+ (NSNumber *) numberHexString:(NSString *)aHexString;
+(NSData*) hexToBytes :(NSString*)hex;
@end
