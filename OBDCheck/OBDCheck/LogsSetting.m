//
//  LogsSetting.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/12.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "LogsSetting.h"

@implementation LogsSetting
#pragma mark - 单例
+ (instancetype)sharedInstance {
    static LogsSetting *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LogsSetting alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
           }
    return self;
}
- (void)initWithlogs{
    LogsModel *model = [LogsModel new];
    model.item1PID = @"Accel X";
    model.item1Smoothing = NO;
    model.item2PID = @"Mass air flow rate";
    model.item2Smoothing = NO;
    model.item3PID = @"Accel X";
    model.item3Enabled = NO;
    model.item3Smoothing = NO;
    model.item4PID = @"Accel Z";
    model.item4Enabled = NO;
    model.item4Smoothing = NO;
    [model bg_saveOrUpdate];
}
- (void)initWithTrips{
    
    for (int i = 0; i<4; i++) {
    TripsModel *model = [TripsModel new];
    model.distance = @"0.0";
    model.Fuel = @"0.0";
    model.FuelEconmy = @"0.0";
    [model bg_saveOrUpdate];
    }
}
@end
