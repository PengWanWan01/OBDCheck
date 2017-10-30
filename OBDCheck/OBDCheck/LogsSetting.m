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
        self.PID1Smoothing = NO;
        self.PID2Smoothing  = NO;
        self.PID3Smoothing = NO;
        self.PID4Smoothing = NO;
        self.PID3Enable = NO;
        self.PID4Enable = NO;
           }
    return self;
}
- (void)initWithlogs{
    LogsModel *model = [LogsModel new];
    model.item1PID = @"vehicle speed";
    model.item1Smoothing = self.PID1Smoothing;
    model.item2PID = @"rotate speed";
    model.item2Smoothing = self.PID2Smoothing;
    model.item3PID = @"water temperature";
    model.item3Enabled = self.PID3Enable;
    model.item3Smoothing = self.PID3Smoothing;
    model.item4PID = @"throttle position";
    model.item4Enabled = self.PID4Enable;
    model.item4Smoothing = self.PID4Smoothing;
    [model bg_saveOrUpdate];
}
- (void)initWithTrips{
    
    for (int i = 0; i<4; i++) {
    TripsModel *model = [TripsModel new];
    model.distance = @"0.00";
    model.Fuel = @"0.00";
    model.FuelEconmy = @"0.00";
    [model bg_saveOrUpdate];
    }
}
@end
