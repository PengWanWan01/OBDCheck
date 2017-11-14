

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
    }
    return self;
}
@end
