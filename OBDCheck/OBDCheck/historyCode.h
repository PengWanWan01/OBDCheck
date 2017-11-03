//
//  historyCode.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/3.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historyCode : NSObject
@property (nonatomic,strong) NSArray *toubleCode;//故障码的内容
@property (nonatomic,copy) NSString *currentTime; //当前时间
@end
