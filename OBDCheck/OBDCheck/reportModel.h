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
@property (nonatomic,copy) NSString *reportSpeedDownTime;
@property (nonatomic,copy) NSString *reportMaxAcceleration;
@property (nonatomic,copy) NSString *reportPeakHorsepower;
@property (nonatomic,copy) NSString *reportAccelerationTest;
@property (nonatomic,copy) NSString *reportDistanceTest;
@property (nonatomic,copy) NSString *reportBrakingSpeed;


@property (nonatomic,copy) NSString *reportUp100Time;


@end
