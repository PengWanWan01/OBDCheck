//
//  reportModel.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/13.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reportModel : NSObject
@property (nonatomic,copy) NSString *reportRunTime;
@property (nonatomic,copy) NSString *reportMaxSpeed;
@property (nonatomic,copy) NSString *reportSpeedUpTime;
@property (nonatomic,copy) NSString *reportSpeedDownDistance;
@property (nonatomic,copy) NSString *reportUp100Time;


@end
