

//
//  reportModel.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/13.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "reportModel.h"

@implementation reportModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reportRunTime = @"--";
        self.reportMaxSpeed = @"--";
        self.reportSpeedDownDistance = @"--";
        self.reportSpeedUpTime = @"--";
        self.reportUp100Time  = @"--";
        self.reportSpeedDownTime = @"--";
        self.reportMaxAcceleration = @"--";
        self.reportPeakHorsepower = @"--";
        self.reportAccelerationTest = @"0-100 km/h";
        self.reportDistanceTest = @"0-100m Time";
        self.reportBrakingSpeed = @"Braking(100-0km/h)";
    }
    return self;
}
@end
